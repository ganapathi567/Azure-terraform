output "principal_id" {
  value = module.ad.principal_id
}

output "object_id" {
  value = module.ad.object_id
}

output "client_id" {
  value = module.ad.client_id
}

output "client_secret" {
  value = module.ad.client_secret
  sensitive = true
}

output "server_application_id" {
  value = module.ad.server_application_id
}

output "client_application_id" {
  value = module.ad.client_application_id
}
