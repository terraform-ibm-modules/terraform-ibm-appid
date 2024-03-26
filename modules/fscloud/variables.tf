variable "region" {
  type        = string
  description = "Region to provision all resources created by this example"
  default     = "us-south"
}

variable "resource_group_id" {
  type        = string
  description = "ID of resource group to use when creating the AppID instance."
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "kms_key_crn" {
  type        = string
  description = "The root key CRN of a Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption."
}

variable "existing_kms_instance_guid" {
  description = "The GUID of the Hyper Protect instance in which the key specified in `kms_key_crn` is coming from."
  type        = string
}

variable "appid_name" {
  type        = string
  description = "The name of the IBM AppID instance."
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

variable "users" {
  description = "List of users to add."
  type        = list(string)
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
  default     = true
}
