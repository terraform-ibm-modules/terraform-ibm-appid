########################################################################################################################
# AppID instance
########################################################################################################################

module "appid" {
  source                              = "../.."
  appid_name                          = var.appid_name
  region                              = var.region
  resource_group_id                   = var.resource_group_id
  resource_tags                       = var.resource_tags
  kms_key_crn                         = var.kms_key_crn
  existing_kms_instance_guid          = var.existing_kms_instance_guid
  skip_iam_authorization_policy       = var.skip_iam_authorization_policy
  kms_encryption_enabled              = true
  plan                                = "graduated-tier"
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
