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

output "appid_name" {
  description = "AppID instance name."
  value       = module.appid.appid_name
}

output "appid_crn" {
  description = "AppID instance CRN."
  value       = module.appid.appid_crn
}
