########################################################################################################################
# Resource Group
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.5"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

########################################################################################################################
# AppID instance
########################################################################################################################

module "appid" {
  source                        = "../.."
  appid_name                    = "${var.prefix}-appid"
  region                        = var.region
  resource_group_id             = module.resource_group.resource_group_id
  resource_tags                 = var.resource_tags
  kms_key_crn                   = var.kms_key_crn
  existing_kms_instance_guid    = var.existing_kms_instance_guid
  skip_iam_authorization_policy = false
  kms_encryption_enabled        = true
  resource_keys                 = [{ name = "${var.prefix}-sc" }]
  users                         = ["user1234@example.com"]
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
