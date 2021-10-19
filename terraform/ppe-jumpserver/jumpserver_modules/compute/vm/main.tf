resource "azurerm_virtual_machine" "vm" {
  count                 = var.vm_count
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = var.nic_ids
  vm_size               = var.vm_size
  zones                 = var.isZonesRequired == true ? var.availability_zones : null

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_name}-os-disk4"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = var.os_disk_size_gb
    managed_disk_type = var.storage_managed_disk_type
  }

#  boot_diagnostics {
#    enabled     = "true"
#    storage_uri = "https://${var.storage_account_name}.blob.core.windows.net/"
#  }

  #identity {
  #  type         = "UserAssigned"
  #  identity_ids = var.user_assigned_identity_ids
  #}

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = "stsAdmin@123"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  #  ssh_keys {
  #    path     = "/home/${var.admin_username}/.ssh/authorized_keys"
  #    key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMNJS6nf9NKz5IIvVFJfzy6iBGy1y7iXPLV6FX0coCBpZ/iNA/7bTNkLCmOrEcm6t4djSHNsmUOutAjRRkgEQIIGzXIOo73ajIn+pJ9gU6iuirWrMDrgwpVcqAnI4s6tKsMKK359sk1f+pXsVeMXJ8ER8e+6vv0+Ik6FFxb6n61EMN33hSd3s+dcqEIxnH7A5lHoc7q6nF2+ZqNqZ4EXXsMyMMkGCXKNcCX2+l7e47b3jWKXHje/lwZXXpMzUx6pVruSHQiXQjCcAXxlqSOrhmuzFYkH66vfzEwupg+kT6bgl/jEpdEuRwiXomMZApt6TNXTgTydTkOjAnepZjyhAN sts-admin@STS-jump-server"
  #  }
  }

  depends_on = [var.module_depends_on]

  tags = var.tags
}
