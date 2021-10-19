output "role_assignment_ids" {
  value = azurerm_role_assignment.role_assignment.*.id
}
