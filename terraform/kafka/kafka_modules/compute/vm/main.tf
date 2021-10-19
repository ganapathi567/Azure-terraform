resource "azurerm_virtual_machine" "vm" {
  count                 = var.vm_count
  name                  = "${var.vm_name}-${count.index + 1}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [element(var.nic_ids, count.index)]
  vm_size               = var.vm_size
  zones                 = var.isZonesRequired == true ? [element(var.availability_zones, count.index)] : null

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_name}-${count.index + 1}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = var.os_disk_size_gb
    managed_disk_type = var.storage_managed_disk_type
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "https://${var.storage_account_name}.blob.core.windows.net/"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = var.user_assigned_identity_ids
  }

  os_profile {
    computer_name  = "${var.vm_name}-${count.index + 1}"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR12Zrs0ocpNCyqEi/0G4Se//qQK8ObIYqsgmjZpY4CuCRXN2ser1rjQW88sQp1EQR9peq8EvIaySHaPXkm6LXToUzS1TCU1fyerV4xNfoLtuY4a1r6fqgoJXDewIienAqHJ550exCrqEgRYXo9luLyUKH7ro2M+ef3BREYN4vXsxU/R6SMeOGyu1f1iZ6uBv9PF1U73HRzzAJmbE3ZLT1fVKq5eCmU2/oiU+bp5rkcdx7HdB4JPfoCcGrh9VcCNZHBwjhjVYC46fy77EmF2fAtqrwTkkwm6PHQbfuAVhzFv91jzTiWgnac8c7OyQAwO+fdjFCb96EiPKVY/6b/a+r sts-admin@eun-ppe-025-sts-jumpserver"
    }
  }

  depends_on = [var.module_depends_on]

  tags = var.tags
}
