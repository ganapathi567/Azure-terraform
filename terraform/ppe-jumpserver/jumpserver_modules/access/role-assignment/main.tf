resource "azurerm_role_assignment" "role_assignment" {
  count              = length(var.role_assignment_scopes)
  scope              = var.role_assignment_scopes[count.index]
  role_definition_id = var.role_definition_id
  principal_id       = var.assignee_principal_id

  lifecycle {
    ignore_changes = [role_definition_id]
  }

  depends_on = [var.module_depends_on]
}
