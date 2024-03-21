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
  validation {
    condition     = contains(["jp-osa", "jp-tok", "us-east", "au-syd", "br-sao", "ca-tor", "eu-de", "eu-gb", "us-south"], var.region)
    error_message = "The specified region is not valid, supported regions are: jp-osa, jp-tok, us-east, au-syd, br-sao, ca-tor, eu-de, eu-gb, us-south."
  }
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID for the AppID resources."
}

variable "resource_keys" {
  description = "The definition of any resource keys to be generated"
  type = list(object({
    name           = string
    role           = optional(string, "Reader")
    service_id_crn = optional(string)
  }))
  default = []
  validation {
    # From: https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_key
    condition = alltrue([
      for key in var.resource_keys : contains(["Writer", "Manager", "Reader"], key.role)
    ])
    error_message = "resource_keys role must be one of 'Writer', 'Manager', 'Reader', reference https://cloud.ibm.com/iam/roles, `AppID` and select `Service` roles."
  }
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits AppID instance in the given resource group to read the encryption key from the Hyper Protect or Key Protect instance passed in var.existing_kms_instance_guid. If set to 'false', a value must be passed for var.existing_kms_instance_guid. No policy is created if var.kms_encryption_enabled is set to 'false'. No policy is created if var.kms_encryption_enabled is set to false."
  default     = false
}

variable "kms_encryption_enabled" {
  type        = bool
  description = "Set this to true to control the encryption keys used to encrypt the data that you store for AppID. If set to false, the data is encrypted by using randomly generated keys. For more info on securing data in AppID, see https://cloud.ibm.com/docs/appid?topic=appid-mng-data"
  default     = false
  nullable    = true
}

variable "kms_key_crn" {
  type        = string
  description = "The root key CRN of a Key Management Services like Key Protect or Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption. Only used if `kms_encryption_enabled` is set to true."
  default     = null
  nullable    = true
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

########################################################################################################################
# Cloud Directory variables
########################################################################################################################

variable "is_idp_cloud_directory_active" {
  description = "Set this to true to set IDP Cloud Directory active."
  type        = bool
  default     = true
}

variable "is_mfa_active" {
  description = "Set this to true to set MFA in IDP Cloud Directory active."
  type        = bool
  default     = true
}

variable "identity_confirm_access_mode" {
  description = "Identity confirm access mode for Cloud Directory (CD). Allowed values are `FULL`, `RESTRICTIVE` and `OFF`."
  type        = string
  default     = "OFF"
  validation {
    condition     = contains(["FULL", "RESTRICTIVE", "OFF"], var.identity_confirm_access_mode)
    error_message = "Allowed values for `identity_confirm_access_mode` are \"FULL\", \"RESTRICTIVE\" and \"OFF\"."
  }
}

variable "identity_field" {
  description = "Identity field for Cloud Directory (CD). Allowed values are `email` and `userName`."
  type        = string
  default     = "email"
  validation {
    condition     = contains(["email", "userName"], var.identity_field)
    error_message = "Allowed values for `identity_field` are \"email\" and \"userName\"."
  }
}

variable "reset_password_enabled" {
  description = "Set this to true to enable password resets."
  type        = bool
  default     = false
}

variable "reset_password_notification_enabled" {
  description = "Set this to true to enable password notifications."
  type        = bool
  default     = false
}

variable "signup_enabled" {
  description = "Set this to true to allow users to signup."
  type        = bool
  default     = false
}

variable "self_service_enabled" {
  description = "Set this to true to allow users to change password and edit user details."
  type        = bool
  default     = false
}

variable "welcome_enabled" {
  description = "Set this to true to send welcome emails to the new users."
  type        = bool
  default     = false
}

########################################################################################################################
# Users variables
########################################################################################################################

variable "users" {
  description = "Number of users to add."
  type        = list(string)
  default     = ["user@example.com"]
}
