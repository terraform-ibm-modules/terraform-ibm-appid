########################################################################################################################
# Resource Group & Service ID
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

resource "ibm_iam_service_id" "resource_keys_existing_serviceids" {
  name        = "${var.prefix}-serviceid"
  description = "ServiceID for ${var.prefix} env to use for resource key credentials"
}

########################################################################################################################
# AppID instance
########################################################################################################################

module "appid" {
  source                     = "../../modules/fscloud"
  appid_name                 = "${var.prefix}-appid"
  resource_group_id          = module.resource_group.resource_group_id
  region                     = var.region
  resource_tags              = var.resource_tags
  kms_key_crn                = var.kms_key_crn
  existing_kms_instance_guid = var.existing_kms_instance_guid
  # for the sake of this example, setting this to false - should be set to true to enable MFA
  is_mfa_active = false
  resource_keys = [{
    name           = "${var.prefix}-writer"
    role           = "Writer"
    service_id_crn = ibm_iam_service_id.resource_keys_existing_serviceids.crn
    },
    {
      name = "${var.prefix}-manager"
      role = "Manager"
    },
    {
      name = "${var.prefix}-reader"
      role = "Reader"
    }
  ]
  users = ["user1234@example.com"]
}

########################################################################################################################
# Create application, scopes and roles.
########################################################################################################################

# create an application
resource "ibm_appid_application" "app" {
  tenant_id = module.appid.tenant_id
  name      = "${var.prefix}-app"
  type      = "singlepageapp" # singlepageapp | regularwebapp
}

# create AppID scope for the application
resource "ibm_appid_application_scopes" "scopes" {
  tenant_id = module.appid.tenant_id
  client_id = ibm_appid_application.app.client_id # AppID application client_id
  scopes    = ["scope_1", "scope_2", "scope_3"]
}

# create AppID role
resource "ibm_appid_role" "role" {
  depends_on = [ibm_appid_application_scopes.scopes] # For creation scope must be created before the roles
  tenant_id  = module.appid.tenant_id
  name       = "${var.prefix}-role"

  access {
    application_id = ibm_appid_application.app.client_id
    scopes         = ["scope_1", "scope_2"]
  }
}

# Assign AppID role to the users
resource "ibm_appid_user_roles" "roles" {
  count     = length(module.appid.user_subjects)
  tenant_id = module.appid.tenant_id
  subject   = module.appid.user_subjects[count.index]
  role_ids  = [ibm_appid_role.role.role_id]
}
