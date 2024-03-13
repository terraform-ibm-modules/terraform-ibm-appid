variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example"
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "appid"
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "user_count" {
  type        = number
  description = "Number of users to be added to the Cloud Directory."
  default     = 1
}

variable "kms_key_crn" {
  type        = string
  description = "The root key CRN of a Key Management Services like Key Protect or Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption. Only used if `kms_encryption_enabled` is set to true."
}

variable "existing_kms_instance_guid" {
  description = "The GUID of the Hyper Protect or Key Protect instance in which the key specified in `kms_key_crn` is coming from. Only required if `skip_iam_authorization_policy` is 'false'."
  type        = string
}
