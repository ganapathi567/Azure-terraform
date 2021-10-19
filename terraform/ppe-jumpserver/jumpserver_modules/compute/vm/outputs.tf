output "ids" {
  value     = azurerm_virtual_machine.vm.*.id
  sensitive = false
}
