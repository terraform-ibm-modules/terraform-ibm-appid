########################################################################################################################
# Resource Group & Service ID
########################################################################################################################

module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.1.5"
  resource_group_name          = var.existing_resource_group == false ? var.resource_group_name : null
  existing_resource_group_name = var.existing_resource_group == true ? var.resource_group_name : null
}

#######################################################################################################################
# KMS Key
#######################################################################################################################

# KMS root key for AppID
module "kms" {
  providers = {
    ibm = ibm.kms
  }
  count                       = var.existing_kms_key_crn != null ? 0 : 1 # no need to create any KMS resources if passing an existing key.
  source                      = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version                     = "4.13.2"
  create_key_protect_instance = false
  region                      = var.kms_region
  existing_kms_instance_guid  = var.existing_kms_instance_guid
  key_ring_endpoint_type      = var.kms_endpoint_type
  key_endpoint_type           = var.kms_endpoint_type
  keys = [
    {
      key_ring_name         = var.key_ring_name
      existing_key_ring     = false
      force_delete_key_ring = true
      keys = [
        {
          key_name                 = var.key_name
          standard_key             = false
          rotation_interval_month  = 3
          dual_auth_delete_enabled = false
          force_delete             = true
        }
      ]
    }
  ]
}

########################################################################################################################
# AppID instance
########################################################################################################################

module "appid" {
  source                              = "../../modules/fscloud"
  appid_name                          = var.appid_name
  resource_group_id                   = module.resource_group.resource_group_id
  region                              = var.region
  resource_tags                       = var.resource_tags
  kms_key_crn                         = var.existing_kms_key_crn != null ? var.existing_kms_key_crn : module.kms[0].keys[format("%s.%s", var.key_ring_name, var.key_name)].crn
  existing_kms_instance_guid          = var.existing_kms_instance_guid
  skip_iam_authorization_policy       = var.skip_iam_authorization_policy
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
