output "ids" {
  value     = azurerm_network_interface.nic.*.id
  sensitive = false
}

output "ip_addresses" {
  value     = azurerm_network_interface.nic.*.private_ip_address
  sensitive = false
}

output "names" {
  value     = azurerm_network_interface.nic.*.name
  sensitive = false
}
