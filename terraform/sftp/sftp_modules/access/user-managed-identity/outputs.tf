output "ids" {
  value = azurerm_user_assigned_identity.managed_identity.*.id
}

output "principal_ids" {
  value = azurerm_user_assigned_identity.managed_identity.*.principal_id
}

output "client_ids" {
  value = azurerm_user_assigned_identity.managed_identity.*.client_id
}
