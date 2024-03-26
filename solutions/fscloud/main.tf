########################################################################################################################
# Resource Group & Service ID
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
  source                              = "../../modules/fscloud"
  appid_name                          = "${var.prefix}-appid"
  resource_group_id                   = module.resource_group.resource_group_id
  region                              = var.region
  resource_tags                       = var.resource_tags
  kms_key_crn                         = var.kms_key_crn
  existing_kms_instance_guid          = var.existing_kms_instance_guid
  resource_keys                       = var.resource_keys
  users                               = var.users
  is_idp_cloud_directory_active       = var.is_idp_cloud_directory_active
  is_mfa_active                       = var.is_mfa_active
  identity_confirm_access_mode        = var.identity_confirm_access_mode
  identity_field                      = var.identity_field
  reset_password_enabled              = var.reset_password_enabled
  reset_password_notification_enabled = var.reset_password_notification_enabled
  signup_enabled                      = var.signup_enabled
  self_service_enabled                = var.self_service_enabled
  welcome_enabled                     = var.welcome_enabled
}
