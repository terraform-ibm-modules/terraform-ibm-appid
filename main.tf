locals {
  # tflint-ignore: terraform_unused_declarations
  validate_kms_plan = var.kms_encryption_enabled && var.plan != "graduated-tier" ? tobool("kms encryption is only supported for graduated-tier plan") : true
  # tflint-ignore: terraform_unused_declarations
  validate_auth_policy = var.kms_encryption_enabled && !var.skip_iam_authorization_policy && var.existing_kms_instance_guid == null ? tobool("When var.skip_iam_authorization_policy is set to false, and var.kms_encryption_enabled to true, a value must be passed for var.existing_kms_instance_guid in order to create the auth policy.") : true
  # tflint-ignore: terraform_unused_declarations
  validate_kms_values = !var.kms_encryption_enabled && (var.existing_kms_instance_guid != null || var.kms_key_crn != null) ? tobool("When passing values for var.existing_kms_instance_guid or/and var.kms_key_crn, you must set var.kms_encryption_enabled to true. Otherwise unset them to use default encryption") : true
  # tflint-ignore: terraform_unused_declarations
  validate_kms_vars = var.kms_encryption_enabled && (var.existing_kms_instance_guid == null || var.kms_key_crn == null) ? tobool("When setting var.kms_encryption_enabled to true, a value must be passed for var.existing_kms_instance_guid and var.kms_key_crn") : true


  # Determine what KMS service is being used for database encryption
  kms_service = var.kms_key_crn != null ? (
    can(regex(".*kms.*", var.kms_key_crn)) ? "kms" : (
      can(regex(".*hs-crypto.*", var.kms_key_crn)) ? "hs-crypto" : null
    )
  ) : null

  parameters_enabled = var.kms_encryption_enabled && var.existing_kms_instance_guid != null && var.kms_key_crn != null ? true : false
}

##############################################################################
# AppID module
##############################################################################

resource "ibm_iam_authorization_policy" "policy" {
  count                       = (var.kms_encryption_enabled && !var.skip_iam_authorization_policy) ? 1 : 0
  source_service_name         = "appid"
  source_resource_group_id    = var.resource_group_id
  description                 = "Allow all AppID instances in the given resource group reader access to KMS instance ${var.existing_kms_instance_guid}"
  target_service_name         = local.kms_service
  target_resource_instance_id = var.existing_kms_instance_guid
  roles = [
    "Reader"
  ]
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
