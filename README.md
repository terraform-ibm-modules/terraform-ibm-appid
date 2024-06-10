<!-- Update the title -->
# IBM AppID

<!--
Update status and "latest release" badges:
  1. For the status options, see https://terraform-ibm-modules.github.io/documentation/#/badge-status
  2. Update the "latest release" badge to point to the correct module's repo. Replace "terraform-ibm-module-template" in two places.
-->
[![Stable (With quality checks)](https://img.shields.io/badge/Status-Stable%20(With%20quality%20checks)-green)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-appid?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-appid/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

<!-- Add a description of module(s) in this repo -->
This module creates an IBM AppID instance and a resource key.

More information about the IBM AppID can be found [here](https://cloud.ibm.com/docs/appid?topic=appid-getting-started)

**Note**: This module creates random password for the new users. Set `self_service_enabled` to `true` to give users permission to change their passwords.

<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-appid](#terraform-ibm-appid)
* [Submodules](./modules)
    * [fscloud](./modules/fscloud)
* [Examples](./examples)
    * [Basic example](./examples/basic)
    * [Financial Services compliant example](./examples/fscloud)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->


<!--
If this repo contains any reference architectures, uncomment the heading below and links to them.
(Usually in the `/reference-architectures` directory.)
See "Reference architecture" in Authoring Guidelines in the public documentation at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=reference-architecture
-->
<!-- ## Reference architectures -->


<!-- This heading should always match the name of the root level module (aka the repo name) -->
## terraform-ibm-appid

### Usage

<!--
Add an example of the use of the module in the following code block.

Use real values instead of "var.<var_name>" or other placeholder values
unless real values don't help users know what to change.
-->

```hcl
provider "ibm" {
  ibmcloud_api_key = "XXXXXXXXXX"
  region           = "us-south"
}

module "appid" {
  source            = "terraform-ibm-modules/appid/ibm"
  version           = "latest" # Replace "latest" with a release version to lock into a specific release
  resource_group_id = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"
  appid_name        = "my-appid"
  region            = "us-south"
}
```

### Required IAM access policies

<!-- PERMISSIONS REQUIRED TO RUN MODULE
If this module requires permissions, uncomment the following block and update
the sample permissions, following the format.
Replace the sample Account and IBM Cloud service names and roles with the
information in the console at
Manage > Access (IAM) > Access groups > Access policies.
-->

<!--
You need the following permissions to run this module.

- Account Management
    - **Sample Account Service** service
        - `Editor` platform access
        - `Manager` service access
    - IAM Services
        - **Sample Cloud Service** service
            - `Administrator` platform access
-->

<!-- NO PERMISSIONS FOR MODULE
If no permissions are required for the module, uncomment the following
statement instead the previous block.
-->

<!-- No permissions are needed to run this module.-->


<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.49.0, < 2.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.0, <4.0.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.8.0, <1.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_appid_cloud_directory_user.user](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/appid_cloud_directory_user) | resource |
| [ibm_appid_idp_cloud_directory.cd](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/appid_idp_cloud_directory) | resource |
| [ibm_appid_mfa.mf](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/appid_mfa) | resource |
| [ibm_iam_authorization_policy.policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_authorization_policy) | resource |
| [ibm_resource_instance.appid](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_key.resource_keys](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_key) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_sleep.wait_for_authorization_policy](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appid_name"></a> [appid\_name](#input\_appid\_name) | Name of the AppID resource. | `string` | n/a | yes |
| <a name="input_existing_kms_instance_guid"></a> [existing\_kms\_instance\_guid](#input\_existing\_kms\_instance\_guid) | The GUID of the Hyper Protect or Key Protect instance in which the key specified in `kms_key_crn` is coming from. Only required if `skip_iam_authorization_policy` is 'false'. | `string` | `null` | no |
| <a name="input_identity_confirm_access_mode"></a> [identity\_confirm\_access\_mode](#input\_identity\_confirm\_access\_mode) | Identity confirm access mode for Cloud Directory (CD). Allowed values are `FULL`, `RESTRICTIVE` and `OFF`. | `string` | `"OFF"` | no |
| <a name="input_identity_field"></a> [identity\_field](#input\_identity\_field) | Identity field for Cloud Directory (CD). Allowed values are `email` and `userName`. | `string` | `"email"` | no |
| <a name="input_is_idp_cloud_directory_active"></a> [is\_idp\_cloud\_directory\_active](#input\_is\_idp\_cloud\_directory\_active) | Set this to true to set IDP Cloud Directory active. | `bool` | `true` | no |
| <a name="input_is_mfa_active"></a> [is\_mfa\_active](#input\_is\_mfa\_active) | Set this to true to set MFA in IDP Cloud Directory active. | `bool` | `true` | no |
| <a name="input_kms_encryption_enabled"></a> [kms\_encryption\_enabled](#input\_kms\_encryption\_enabled) | Set this to true to control the encryption keys used to encrypt the data that you store for AppID. If set to false, the data is encrypted by using randomly generated keys. For more info on securing data in AppID, see https://cloud.ibm.com/docs/appid?topic=appid-mng-data | `bool` | `false` | no |
| <a name="input_kms_key_crn"></a> [kms\_key\_crn](#input\_kms\_key\_crn) | The root key CRN of a Key Management Services like Key Protect or Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption. Only used if `kms_encryption_enabled` is set to true. | `string` | `null` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | Plan for the AppID resource. | `string` | `"graduated-tier"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region for the AppID resource. | `string` | n/a | yes |
| <a name="input_reset_password_enabled"></a> [reset\_password\_enabled](#input\_reset\_password\_enabled) | Set this to true to enable password resets. | `bool` | `false` | no |
| <a name="input_reset_password_notification_enabled"></a> [reset\_password\_notification\_enabled](#input\_reset\_password\_notification\_enabled) | Set this to true to enable password notifications. | `bool` | `false` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | Resource group ID for the AppID resources. | `string` | n/a | yes |
| <a name="input_resource_keys"></a> [resource\_keys](#input\_resource\_keys) | The definition of any resource keys to be generated. Valid service roles are `Writer`, `Reader` and `Manager`. | <pre>list(object({<br>    name           = string<br>    role           = optional(string, "Reader")<br>    service_id_crn = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | Optional list of tags to be added to created resources | `list(string)` | `[]` | no |
| <a name="input_self_service_enabled"></a> [self\_service\_enabled](#input\_self\_service\_enabled) | Set this to true to allow users to change password and edit user details. | `bool` | `false` | no |
| <a name="input_signup_enabled"></a> [signup\_enabled](#input\_signup\_enabled) | Set this to true to allow users to signup. | `bool` | `false` | no |
| <a name="input_skip_iam_authorization_policy"></a> [skip\_iam\_authorization\_policy](#input\_skip\_iam\_authorization\_policy) | Set to true to skip the creation of an IAM authorization policy that permits AppID instance in the given resource group to read the encryption key from the Hyper Protect or Key Protect instance passed in var.existing\_kms\_instance\_guid. If set to 'false', a value must be passed for var.existing\_kms\_instance\_guid. No policy is created if var.kms\_encryption\_enabled is set to 'false'. | `bool` | `false` | no |
| <a name="input_users"></a> [users](#input\_users) | List of users to add. | `list(string)` | `[]` | no |
| <a name="input_welcome_enabled"></a> [welcome\_enabled](#input\_welcome\_enabled) | Set this to true to send welcome emails to the new users. | `bool` | `false` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_appid_crn"></a> [appid\_crn](#output\_appid\_crn) | AppID instance CRN. |
| <a name="output_appid_name"></a> [appid\_name](#output\_appid\_name) | AppID instance name. |
| <a name="output_dashboard_url"></a> [dashboard\_url](#output\_dashboard\_url) | AppID dashboard url. |
| <a name="output_id"></a> [id](#output\_id) | AppID instance ID. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | AppID instance guid, also called as tenant\_id. |
| <a name="output_user_subjects"></a> [user\_subjects](#output\_user\_subjects) | The user's identifier. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
