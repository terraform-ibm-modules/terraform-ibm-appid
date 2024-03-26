# Advanced example

An end-to-end example that will provision the following:
- A new resource group if one is not passed in.
- Creates serviceIds for "Reader", "Manager" and "Writer" roles.
- An IAM authorization policy for AppID instance to read from KMS instance.
- An AppID instance and a resource key.
- A Cloud Directory authentication with Multi-factor authentication (MFA) enabled.
- Adds a user to the Cloud Directory, and generates random password for the user.
- Creates an application, scopes and roles.
- Assign roles to the users.
