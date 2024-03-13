########################################################################################################################
# Input variables
########################################################################################################################

variable "appid_name" {
  type        = string
  description = "Name of the AppID resource."
}

variable "plan" {
  type        = string
  description = "Plan for the AppID resource."
  default     = "graduated-tier"
  validation {
    condition     = contains(["graduated-tier", "lite"], var.plan)
    error_message = "Allowed values for `plan` are \"graduated-tier\", and \"lite\"."
  }
}

variable "region" {
  type        = string
  description = "Region for the AppID resource."
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID for the AppID resources."
}

variable "appid_key_name" {
  type        = string
  description = "Name of the AppID key."
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits AppID instance in the given resource group to read the encryption key from the Hyper Protect or Key Protect instance passed in var.existing_kms_instance_guid. If set to 'false', a value must be passed for var.existing_kms_instance_guid. No policy is created if var.kms_encryption_enabled is set to 'false'."
  default     = true
}

variable "kms_key_crn" {
  type        = string
  description = "The root key CRN of a Key Management Services like Key Protect or Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption. Only used if `kms_encryption_enabled` is set to true."
  default     = null
  validation {
    condition = anytrue([
      var.kms_key_crn == null,
      can(regex(".*kms.*", var.kms_key_crn)),
      can(regex(".*hs-crypto.*", var.kms_key_crn)),
    ])
    error_message = "Value must be the root key CRN from either the Key Protect or Hyper Protect Crypto Service (HPCS)."
  }
}

variable "existing_kms_instance_guid" {
  description = "The GUID of the Hyper Protect or Key Protect instance in which the key specified in `kms_key_crn` is coming from. Only required if `skip_iam_authorization_policy` is 'false'."
  type        = string
  default     = null
}
