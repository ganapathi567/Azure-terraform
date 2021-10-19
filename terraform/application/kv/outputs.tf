output "app_resource_group_name" {
  value       = azurerm_resource_group.app_resource_group.name
  description = "Global resource group name"
}

output "app_resource_group_location" {
  value       = azurerm_resource_group.app_resource_group.location
  description = "Global resource group location"
}

output "app_keyvault_id" {
  value       = join("", azurerm_key_vault.app_key_vault.*.id)
  description = "Global KeyVault ID"
}

output "app_keyvault_name" {
  value       = join("", azurerm_key_vault.app_key_vault.*.name)
  description = "Global KeyVault name"
}
