########################################################################################################################
# Resource Group
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.4"
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
}

########################################################################################################################
# Manage authentications
########################################################################################################################

resource "ibm_appid_idp_cloud_directory" "cd" {
  tenant_id                           = module.appid.tenant_id
  is_active                           = true
  identity_confirm_access_mode        = "OFF"
  identity_field                      = "userName"
  reset_password_enabled              = false
  reset_password_notification_enabled = false
  signup_enabled                      = false
  self_service_enabled                = false
  welcome_enabled                     = true
}

resource "ibm_appid_mfa" "mf" {
  tenant_id = module.appid.tenant_id
  is_active = true
}

########################################################################################################################
# Add users to the Cloud Directory
########################################################################################################################

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#-"
}

resource "ibm_appid_cloud_directory_user" "user" {
  depends_on = [ibm_appid_idp_cloud_directory.cd] # For deletion user must be deleted before the Cloud Directory

  tenant_id = module.appid.tenant_id

  email {
    value   = "attendee-1@example.com"
    primary = true
  }

  active = true

  user_name = "${var.prefix}-${format("%02d", 1)}"
  password  = random_password.password.result

  display_name = "${var.prefix}-${format("%02d", 1)}"

  create_profile = true
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
  tenant_id = module.appid.tenant_id
  subject   = ibm_appid_cloud_directory_user.user.subject
  role_ids  = [ibm_appid_role.role.role_id]
}
