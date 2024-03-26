variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this DA"
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this DA"
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this DA, if unset a new resource group will be created"
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "kms_key_crn" {
  type        = string
  description = "The root key CRN of a Key Management Services like Key Protect or Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption."
}

variable "existing_kms_instance_guid" {
  description = "The GUID of the Hyper Protect or Key Protect instance in which the key specified in `kms_key_crn` is coming from."
  type        = string
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

variable "kms_encryption_enabled" {
  type        = bool
  description = "Set this to true to control the encryption keys used to encrypt the data that you store for AppID. If set to false, the data is encrypted by using randomly generated keys. For more info on securing data in AppID, see https://cloud.ibm.com/docs/appid?topic=appid-mng-data"
  default     = true
}
