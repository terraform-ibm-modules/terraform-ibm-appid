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

output "writer_resource_key" {
  value       = length(ibm_resource_key.resource_keys) > 0 ? ibm_resource_key.resource_keys[0].credentials["Writer"] : null
  description = "AppID service key for `Writer` role."
  sensitive   = true
}

output "reader_resource_key" {
  value       = length(ibm_resource_key.resource_keys) > 0 ? ibm_resource_key.resource_keys[0].credentials["Reader"] : null
  description = "AppID service key for `Reader` role."
  sensitive   = true
}

output "manager_resource_key" {
  value       = length(ibm_resource_key.resource_keys) > 0 ? ibm_resource_key.resource_keys[0].credentials["Manager"] : null
  description = "AppID service key for `Manager` role."
  sensitive   = true
}

output "appid_name" {
  description = "AppID instance name."
  value       = ibm_resource_instance.appid.name
}

output "appid_crn" {
  description = "AppID instance CRN."
  value       = ibm_resource_instance.appid.target_crn
}
