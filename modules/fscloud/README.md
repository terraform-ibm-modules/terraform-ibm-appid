# Profile for IBM Cloud Framework for Financial Services

This code is a version of the [parent root module](../../) that includes a default configuration that complies with the relevant controls from the [IBM Cloud Framework for Financial Services](https://cloud.ibm.com/docs/framework-financial-services?topic=framework-financial-services-about). See the [Example for IBM Cloud Framework for Financial Services](/examples/fscloud/) for logic that uses this module. The profile assumes you are deploying into an account that is in compliance with the framework.

The default values in this profile were scanned by [IBM Code Risk Analyzer (CRA)](https://cloud.ibm.com/docs/code-risk-analyzer-cli-plugin?topic=code-risk-analyzer-cli-plugin-cra-cli-plugin#terraform-command) for compliance with the IBM Cloud Framework for Financial Services profile that is specified by the IBM Security and Compliance Center.

### Usage

```hcl
provider "ibm" {
  ibmcloud_api_key = "XXXXXXXXXX"
  region           = "us-south"
}

module "appid" {
  source            = "terraform-ibm-modules/appid/ibm"
  version           = "X.X.X" # Replace "X.X.X" with a release version to lock into a specific release
  resource_group_id = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"
  appid_name        = "my-appid"
  region            = "us-south"
  skip_iam_authorization_policy = false
  kms_encryption_enabled        = true
  existing_kms_instance_guid = "<hpcs-instance-guid>"
  kms_key_crn                = "<hpcs-key-crn>"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, <1.7.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.49.0, < 2.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.8.0, <1.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_appid"></a> [appid](#module\_appid) | ../.. | n/a |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appid_name"></a> [appid\_name](#input\_appid\_name) | The name of the IBM AppID instance. | `string` | n/a | yes |
| <a name="input_existing_kms_instance_guid"></a> [existing\_kms\_instance\_guid](#input\_existing\_kms\_instance\_guid) | The GUID of the Hyper Protect instance in which the key specified in `kms_key_crn` is coming from. | `string` | n/a | yes |
| <a name="input_kms_encryption_enabled"></a> [kms\_encryption\_enabled](#input\_kms\_encryption\_enabled) | Set this to true to control the encryption keys used to encrypt the data that you store for AppID. If set to false, the data is encrypted by using randomly generated keys. For more info on securing data in AppID, see https://cloud.ibm.com/docs/appid?topic=appid-mng-data | `bool` | `true` | no |
| <a name="input_kms_key_crn"></a> [kms\_key\_crn](#input\_kms\_key\_crn) | The root key CRN of a Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region to provision all resources created by this example | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | ID of resource group to use when creating the AppID instance. | `string` | n/a | yes |
| <a name="input_resource_keys"></a> [resource\_keys](#input\_resource\_keys) | The definition of any resource keys to be generated. | <pre>list(object({<br>    name           = string<br>    role           = optional(string, "Reader")<br>    service_id_crn = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | Optional list of tags to be added to created resources | `list(string)` | `[]` | no |
| <a name="input_skip_iam_authorization_policy"></a> [skip\_iam\_authorization\_policy](#input\_skip\_iam\_authorization\_policy) | Set to true to skip the creation of an IAM authorization policy that permits AppID instance in the given resource group to read the encryption key from the Hyper Protect or Key Protect instance passed in var.existing\_kms\_instance\_guid. If set to 'false', a value must be passed for var.existing\_kms\_instance\_guid. No policy is created if var.kms\_encryption\_enabled is set to 'false'. No policy is created if var.kms\_encryption\_enabled is set to false. | `bool` | `false` | no |
| <a name="input_users"></a> [users](#input\_users) | List of users to add. | `list(string)` | `[]` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_dashboard_url"></a> [dashboard\_url](#output\_dashboard\_url) | AppID dashboard url. |
| <a name="output_id"></a> [id](#output\_id) | AppID instance ID. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | Tenant ID of the AppID resource |
| <a name="output_user_subjects"></a> [user\_subjects](#output\_user\_subjects) | The user's identifier. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
