locals {
  # tflint-ignore: terraform_unused_declarations
  validate_kms_vars = !var.skip_iam_authorization_policy && var.kms_key_crn == null && var.existing_kms_instance_guid == null ? tobool("When setting var.skip_iam_authorization_policy to true, a value must be passed for var.kms_key_crn and var.existing_kms_instance_guid") : true

  # Determine what KMS service is being used for database encryption
  kms_service = var.kms_key_crn != null ? (
    can(regex(".*kms.*", var.kms_key_crn)) ? "kms" : (
      can(regex(".*hs-crypto.*", var.kms_key_crn)) ? "hs-crypto" : null
    )
  ) : null
}

##############################################################################
# AppID module
##############################################################################

resource "ibm_iam_authorization_policy" "policy" {
  count                       = var.skip_iam_authorization_policy ? 0 : 1
  source_service_name         = "appid"
  source_resource_group_id    = var.resource_group_id
  description                 = "Allow AppID instance to read from KMS instance"
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
  parameters = {
    kms_info = "{\"id\": \"${var.existing_kms_instance_guid}\"}"
    tek_id   = var.kms_key_crn
  }
}

resource "ibm_resource_key" "appid" {
  resource_instance_id = ibm_resource_instance.appid.id
  role                 = "Writer"
  name                 = var.appid_key_name
  tags                 = var.resource_tags
}
