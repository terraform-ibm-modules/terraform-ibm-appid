##############################################################################
# Outputs
##############################################################################

output "tenant_id" {
  description = "Tenant ID of the AppID resource"
  value       = module.appid.tenant_id
}

output "id" {
  description = "AppID instance ID."
  value       = module.appid.id
}

output "dashboard_url" {
  description = "AppID dashboard url."
  value       = module.appid.dashboard_url
}

output "user_subjects" {
  description = "The user's identifier."
  value       = module.appid.user_subjects
}

output "writer_resource_key" {
  value       = module.appid.writer_resource_key
  description = "AppID service key for `Writer` role."
  sensitive   = true
}

output "reader_resource_key" {
  value       = module.appid.reader_resource_key
  description = "AppID service key for `Reader` role."
  sensitive   = true
}

output "manager_resource_key" {
  value       = module.appid.manager_resource_key
  description = "AppID service key for `Manager` role."
  sensitive   = true
}

output "appid_name" {
  description = "AppID instance name."
  value       = module.appid.appid_name
}

output "appid_crn" {
  description = "AppID instance CRN."
  value       = module.appid.appid_crn
}
