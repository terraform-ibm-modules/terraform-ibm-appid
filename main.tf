module "kms_key_crn_parser" {
  count   = var.kms_encryption_enabled != false ? 1 : 0
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.4.2"
  crn     = var.kms_key_crn
}

locals {
  kms_service    = var.kms_key_crn != null ? module.kms_key_crn_parser[0].service_name : null
  kms_account_id = var.kms_key_crn != null ? module.kms_key_crn_parser[0].account_id : null
  kms_key_id     = var.kms_key_crn != null ? module.kms_key_crn_parser[0].resource : null


  parameters_enabled = var.kms_encryption_enabled && var.existing_kms_instance_guid != null && var.kms_key_crn != null ? true : false
}

##############################################################################
# AppID module
##############################################################################

resource "ibm_iam_authorization_policy" "policy" {
  count                    = (var.kms_encryption_enabled && !var.skip_iam_authorization_policy) ? 1 : 0
  source_service_name      = "appid"
  source_resource_group_id = var.resource_group_id
  description              = "Allow all AppID instances in the given resource group ${var.resource_group_id} to read the ${local.kms_service} key ${local.kms_key_id} from instance ${var.existing_kms_instance_guid}"
  roles = [
    "Reader"
  ]

  resource_attributes {
    name     = "serviceName"
    operator = "stringEquals"
    value    = local.kms_service
  }
  resource_attributes {
    name     = "accountId"
    operator = "stringEquals"
    value    = local.kms_account_id
  }
  resource_attributes {
    name     = "serviceInstance"
    operator = "stringEquals"
    value    = var.existing_kms_instance_guid
  }
  resource_attributes {
    name     = "resourceType"
    operator = "stringEquals"
    value    = "key"
  }
  resource_attributes {
    name     = "resource"
    operator = "stringEquals"
    value    = local.kms_key_id
  }
  # Scope of policy now includes the key, so ensure to create new policy before
  # destroying old one to prevent any disruption to every day services.
  lifecycle {
    create_before_destroy = true
  }
}

# workaround for https://github.com/IBM-Cloud/terraform-provider-ibm/issues/4478
resource "time_sleep" "wait_for_authorization_policy" {
  depends_on = [ibm_iam_authorization_policy.policy]

  create_duration = "30s"
}

resource "ibm_resource_instance" "appid" {
  depends_on        = [time_sleep.wait_for_authorization_policy]
  name              = var.appid_name
  service           = "appid"
  plan              = var.plan
  location          = var.region
  resource_group_id = var.resource_group_id
  tags              = var.resource_tags
  parameters = local.parameters_enabled ? {
    kms_info = "{\"id\": \"${var.existing_kms_instance_guid}\"}"
    tek_id   = var.kms_key_crn
  } : null
}

resource "ibm_resource_key" "resource_keys" {
  for_each             = { for key in var.resource_keys : key.name => key }
  name                 = each.key
  resource_instance_id = ibm_resource_instance.appid.id
  role                 = each.value.role
}

########################################################################################################################
# Manage authentications
########################################################################################################################

resource "ibm_appid_idp_cloud_directory" "cd" {
  tenant_id                           = ibm_resource_instance.appid.guid
  is_active                           = var.is_idp_cloud_directory_active
  identity_confirm_access_mode        = var.identity_confirm_access_mode
  identity_field                      = var.identity_field
  reset_password_enabled              = var.reset_password_enabled
  reset_password_notification_enabled = var.reset_password_notification_enabled
  signup_enabled                      = var.signup_enabled
  self_service_enabled                = var.self_service_enabled
  welcome_enabled                     = var.welcome_enabled
}

resource "ibm_appid_mfa" "mf" {
  tenant_id = ibm_resource_instance.appid.guid
  is_active = var.is_mfa_active
}

########################################################################################################################
# Add users to the Cloud Directory
########################################################################################################################

resource "random_password" "password" {
  count            = length(var.users)
  length           = 16
  special          = true
  override_special = "!#-"
}

resource "ibm_appid_cloud_directory_user" "user" {
  depends_on = [ibm_appid_idp_cloud_directory.cd] # For deletion user must be deleted before the Cloud Directory
  count      = length(var.users)
  tenant_id  = ibm_resource_instance.appid.guid

  email {
    value   = var.users[count.index]
    primary = true
  }

  user_name      = split("@", var.users[count.index])[0]
  active         = true
  password       = random_password.password[count.index].result
  create_profile = true
}
