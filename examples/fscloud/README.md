# Financial Services compliant example

This example uses the [Profile for IBM Cloud Framework for Financial Services](https://github.com/terraform-ibm-modules/terraform-ibm-appid/tree/main/profiles/fscloud) to provision an IBM AppID instance.

The following resources are provisioned by this example:

- A new resource group if one is not passed in.
- Creates a serviceIds for a "Writer" role.
- An IAM authorization policy for AppID instance to read from KMS instance.
- An AppID instance and a resource key.
- A Cloud Directory authentication with Multi-factor authentication (MFA) enabled.
- It takes list of users in and add them in the Cloud Directory. It generates random password for each user.
- Creates an application, scopes and roles.
- Assign roles to the users.

:exclamation: **Important:** In this example, only the IBM AppID resources complies with the IBM Cloud Framework for Financial Services. Other parts of the infrastructure do not necessarily comply.

## Before you begin

Before you run the example, make sure that you set up the following prerequisites:

- A Hyper Protect Crypto Services (HPCS) instance and root key that you want to secure data with the AppID.
