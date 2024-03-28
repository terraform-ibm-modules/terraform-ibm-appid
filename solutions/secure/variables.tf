variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this solution."
  default     = "us-south"
}

variable "existing_resource_group" {
  type        = bool
  description = "Whether to use an existing resource group."
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of a new or an existing resource group in which to provision AppID resources to."
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "appid_name" {
  type        = string
  description = "The name of the IBM AppID instance."
}

variable "users" {
  description = "List of users to add."
  type        = list(string)
  default     = []
}

variable "resource_keys" {
  description = "The definition of any resource keys to be generated."
  type = list(object({
    name           = string
    role           = optional(string, "Reader")
    service_id_crn = optional(string)
  }))
  default = []
}

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
# KMS variables
########################################################################################################################

variable "kms_region" {
  type        = string
  default     = "us-south"
  description = "The region in which KMS instance exists."
}

variable "existing_kms_instance_guid" {
  description = "The GUID of the Hyper Protect or Key Protect instance in which the key specified in `existing_kms_key_crn` is coming from."
  type        = string
  default     = null
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits AppID instance in the given resource group to read the encryption key from the Hyper Protect or Key Protect instance passed in var.existing_kms_instance_guid. If set to 'false', a value must be passed for var.existing_kms_instance_guid."
  default     = false
}

variable "existing_kms_key_crn" {
  type        = string
  description = "The root key CRN of an existing Key Management Services like Key Protect or Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption."
  default     = null
}

variable "kms_endpoint_type" {
  type        = string
  description = "The type of endpoint to be used for communicating with the KMS instance. Allowed values are: 'public' or 'private' (default)"
  default     = "private"
  validation {
    condition     = can(regex("public|private", var.kms_endpoint_type))
    error_message = "The kms_endpoint_type value must be 'public' or 'private'."
  }
}

variable "key_ring_name" {
  type        = string
  default     = "appid-key-ring"
  description = "The name to give the Key Ring which will be created for the AppID Key. Not used if supplying an existing Key."
}

variable "key_name" {
  type        = string
  default     = "appid-key"
  description = "The name to give the Key which will be created for the AppID. Not used if supplying an existing Key."
}
