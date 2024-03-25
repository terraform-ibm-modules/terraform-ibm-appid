########################################################################################################################
# AppID instance
########################################################################################################################

module "appid" {
  source                        = "../.."
  appid_name                    = var.appid_name
  region                        = var.region
  resource_group_id             = var.resource_group_id
  resource_tags                 = var.resource_tags
  kms_key_crn                   = var.kms_key_crn
  existing_kms_instance_guid    = var.existing_kms_instance_guid
  skip_iam_authorization_policy = var.skip_iam_authorization_policy
  kms_encryption_enabled        = var.kms_encryption_enabled
  resource_keys                 = var.resource_keys
  users                         = var.users
}
