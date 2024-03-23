##############################################################################
# Outputs
##############################################################################

output "tenant_id" {
  description = "Tenant ID of the AppID resource"
  value       = module.appid.tenant_id
}

output "client_id" {
  description = "Client ID of the application."
  value       = ibm_appid_application.app.client_id
}

output "id" {
  description = "AppID instance ID."
  value       = module.appid.id
}

output "dashboard_url" {
  description = "AppID dashboard url."
  value       = module.appid.dashboard_url
}
