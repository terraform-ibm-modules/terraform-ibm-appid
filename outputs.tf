########################################################################################################################
# Outputs
########################################################################################################################

output "tenant_id" {
  description = "AppID instance guid, also called as tenant_id."
  value       = ibm_resource_instance.appid.guid
}

output "id" {
  description = "AppID instance ID."
  value       = ibm_resource_instance.appid.id
}

output "dashboard_url" {
  description = "AppID dashboard url."
  value       = ibm_resource_instance.appid.dashboard_url
}

output "user_subjects" {
  description = "The user's identifier."
  value       = ibm_appid_cloud_directory_user.user[*].subject
}
