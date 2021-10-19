resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.vm_name}-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name}-${count.index + 1}-nic-configuration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address_allocation == "Static" ? element(var.private_ip_addresses, count.index) : null
  }

  #depends_on = [var.module_depends_on]

  tags = var.tags
}
