terraform {
  required_version = ">= 1.3.0"

  # Lock DA into an exact provider version - renovate automation will keep it updated
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.66.0"
    }
    # tflint-ignore: terraform_unused_required_providers
    time = {
      source  = "hashicorp/time"
      version = ">= 0.11.2, < 1.0.0"
    }
    # tflint-ignore: terraform_unused_required_providers
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.2, < 4.0.0"
    }
  }
}
