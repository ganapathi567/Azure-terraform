resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                  = var.resource_name
  location              = var.location
  resource_group_name   = var.mongo_resource_group_name
  upgrade_policy_mode   = "Automatic"
  #zones can be used only standard lb
  zones                 = [1, 2, 3]

  sku {
    name     = var.vmss_size
    capacity = var.vmss_count
  }

  os_profile {
    computer_name_prefix  = var.resource_name
    admin_username        = var.admin_username
    #user_data             = base64encode(var.script_file_content)
    custom_data = base64encode(var.script_file_content)
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR12Zrs0ocpNCyqEi/0G4Se//qQK8ObIYqsgmjZpY4CuCRXN2ser1rjQW88sQp1EQR9peq8EvIaySHaPXkm6LXToUzS1TCU1fyerV4xNfoLtuY4a1r6fqgoJXDewIienAqHJ550exCrqEgRYXo9luLyUKH7ro2M+ef3BREYN4vXsxU/R6SMeOGyu1f1iZ6uBv9PF1U73HRzzAJmbE3ZLT1fVKq5eCmU2/oiU+bp5rkcdx7HdB4JPfoCcGrh9VcCNZHBwjhjVYC46fy77EmF2fAtqrwTkkwm6PHQbfuAVhzFv91jzTiWgnac8c7OyQAwO+fdjFCb96EiPKVY/6b/a+r sts-admin@eun-ppe-025-sts-jumpserver"
    }
  }

 # identity {
 #   type         = "UserAssigned"
 #   identity_ids = var.user_assigned_identity_ids
 # }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
    
  }

  storage_profile_os_disk {
    #name          = "sts-dev-mongo-config"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS" 
  }

  storage_profile_data_disk {
    #name  	 = ""
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 500
    managed_disk_type = "Premium_LRS"
  }

#  boot_diagnostics {
#    enabled = true
#    storage_uri = "https://${var.storage_account_name}.blob.core.windows.net/"
#  }

  network_profile {
    name    = var.resource_name
    primary = true
    accelerated_networking = false 
    ip_forwarding          = false
    dns_settings {
        dns_servers = []
}

    ip_configuration {
      name                                   = var.resource_name
      primary                                = true
      subnet_id                              = var.mongo_subnet_id
      #load_balancer_backend_address_pool_ids = var.lb_beap_ids
      #load_balancer_inbound_nat_rules_ids    = var.lb_nat_ids
    }
  }

  #depends_on = [var.module_depends_on]

  tags = var.tags
}
