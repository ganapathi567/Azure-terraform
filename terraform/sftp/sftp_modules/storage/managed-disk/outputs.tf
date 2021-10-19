output "ids" {
    value = azurerm_managed_disk.data_disk.*.id
}

output "names" {
  value = azurerm_managed_disk.data_disk.*.name
}

output "disk_sizes_gb" {
  value = azurerm_managed_disk.data_disk.*.disk_size_gb
}
