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
