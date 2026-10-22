# Financial Services compliant AppID Deployable Architecture (DA)

This DA uses the [Profile for IBM Cloud Framework for Financial Services](https://github.com/terraform-ibm-modules/terraform-ibm-appid/tree/main/profiles/fscloud) to provision an IBM AppID instance.

The following resources are provisioned by this DA:

- A new resource group if one is not passed in.
- Creates a serviceIds for a "Writer" role.
- Optionally, creates KMS root key for AppID.
- An IAM authorization policy for AppID instance to read from KMS instance.
- An AppID instance.
- Optionally, supports creating resource keys.
- A Cloud Directory authentication with Multi-factor authentication (MFA) enabled.
- It takes list of users in and add them in the Cloud Directory. It generates random password for each user.
- Creates an application, scopes and roles.
- Assign roles to the users.

**Note**: This DA creates random password for the new users. Set `self_service_enabled` to `true` to give users permission to change their passwords.

## Before you begin

Before you run the DA, make sure that you set up the following prerequisites:

- A Hyper Protect Crypto Services (HPCS) instance and root key that you want to secure data with the AppID.
