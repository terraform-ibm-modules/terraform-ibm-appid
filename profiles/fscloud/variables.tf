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
