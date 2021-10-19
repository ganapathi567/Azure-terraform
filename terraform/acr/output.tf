output "global_resource_group_name" {
  value = module.global.global_resource_group_name
}

output "global_resource_group_location" {
  value = module.global.global_resource_group_location
}

output "global_keyvault_id" {
  value = module.global.global_keyvault_id
}

output "global_keyvault_name" {
  value = module.global.global_keyvault_name
  sensitive = true
}

output "global_containter_registry_url" {
  value = module.global.global_containter_registry_url
}

output "global_containter_registry_id" {
  value = module.global.global_containter_registry_id
}

output "global_containter_registry_name" {
  value = module.global.global_containter_registry_name
}
