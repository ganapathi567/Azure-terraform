#resource "azurerm_public_ip" "sts_dev_sftp_pip" {
#  name                = "${var.vm_name}-pip"
#  resource_group_name = var.resource_group_name
#  location            = var.location
#  sku                 = "Standard"
#  allocation_method   = "Static"
#
#  depends_on = [var.resource_group_name]
#  tags = var.tags
#}


resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name}-nic"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    #private_ip_address            = var.private_ip_address_allocation == "Static" ? var.private_ip_addresses : null
    #public_ip_address_id          = azurerm_public_ip.sts_dev_sftp_pip.id
  }

  depends_on = [var.module_depends_on]

  tags = var.tags
}
