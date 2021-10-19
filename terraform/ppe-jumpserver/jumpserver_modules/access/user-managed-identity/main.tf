resource "azurerm_user_assigned_identity" "managed_identity" {
  count               = length(var.resource_names)
  resource_group_name = var.resource_group_name
  location            = var.region
  name                = "${element(var.resource_names, count.index)}-mi" 

  tags = var.tags
}
