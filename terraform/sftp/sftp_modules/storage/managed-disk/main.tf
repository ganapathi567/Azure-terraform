resource "azurerm_managed_disk" "data_disk" {
  count                = var.vm_count
  name                 = "${var.vm_name}-data-disk"
  resource_group_name  = var.resource_group
  location             = var.region
  zones                = [element(var.availability_zones, count.index)]
  storage_account_type = var.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_gb

  depends_on = [var.module_depends_on]

  tags = var.tags
}
