provider "azurerm" {
 version = "=2.1.0"
  features {}
subscription_id = var.subscription_id
tenant_id = var.tenant_id
}


locals {
  subscription_id        = var.subscription_id
  shortcodes             = split("-", var.subscription_name)
  location               = lower(var.location)
  region_shortcode       = (local.location == "westeurope" ? "euw" : (local.location == "northeurope" ? "eun" : (local.location == "southeastasia" ? "ase" : (local.location == "eastasia" ? "aea" : "unknown"))))
  environment            = (var.tesco_environment == "" ? lower(element(local.shortcodes, 1)) : lower(var.tesco_environment))
  tesco_team_name        = lower(var.tesco_team_name)
  team_number            = element(local.shortcodes, 0)
  resource_base_name     = join("-", [local.region_shortcode, local.environment, local.team_number, local.tesco_team_name])
  resource_name          = join("-", [local.resource_base_name, "jumpserver"])
  admin_username         = join("-", [local.tesco_team_name, "admin"])
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tesco_tags
}

resource "azurerm_subnet" "sts_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.networking_resource_group_name
  virtual_network_name = var.networking_learnedroutes_vnet_name
  address_prefix       = var.subnet_cidr
}

#resource "azurerm_public_ip" "sts_pip" {
#  name                = var.resource_name
#  resource_group_name = var.resource_group_name
#  location            = var.location
#  sku                 = "Standard"
#  allocation_method   = "Static"
#
#  depends_on = [var.resource_group_name]
#  tags = var.tesco_tags
#}

module "nic" {
  source = "./jumpserver_modules/compute/nic"

  resource_group_name           = var.resource_group_name
  location                      = var.location
  vm_count                      = var.vm_count
  vm_name                       = var.resource_name
  subnet_id                     = azurerm_subnet.sts_subnet.id 
  private_ip_address_allocation = "Dynamic"
  #private_ip_address_allocation = "Static"
  #sts_pip_id 		= azurerm_public_ip.sts_pip.id

  tags = var.tesco_tags
}


resource "azurerm_network_security_group" "subnet_nsg" {
  name                  = var.subnet_nsg
  location              = var.location
  resource_group_name   = var.resource_group_name 

  tags = var.tesco_tags
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  subnet_id                 = azurerm_subnet.sts_subnet.id
  network_security_group_id = azurerm_network_security_group.subnet_nsg.id
}

resource "azurerm_subnet_route_table_association" "subnet_hubinternet" {
  subnet_id      = azurerm_subnet.sts_subnet.id
  #route_table_id = azurerm_route_table.route_table.id
  route_table_id = "/subscriptions/9f813689-c99d-4bb7-8f2f-cf48b6b7c046/resourceGroups/eun-prod-025-frs-net/providers/Microsoft.Network/routeTables/eun-prod-025-frs-hubinternet"
}

module "vm" {
  source = "./jumpserver_modules/compute/vm"

  resource_group_name = var.resource_group_name
  location            = var.location

  vm_count           = var.vm_count
  vm_name            = var.resource_name 
  vm_size            = var.vm_size
  nic_ids            = module.nic.ids
  #sts_pip_id = azurerm_public_ip.sts_pip.id

  #storage_account_name = data.azurerm_storage_account.sts_app_storage.name 

  #storage_caching           = "ReadWrite"
  #storage_create_option     = "FromImage"
  #storage_disk_size_gb      = 30
  storage_managed_disk_type = "Standard_LRS"

  admin_username      = var.admin_username
  ssh_public_key_data = var.ssh_public_key_data

  #user_assigned_identity_ids = module.managed_identity.ids

  tags = var.tesco_tags
}

#module "vm_ext" {
#  source = "./jumpserver_modules/compute/vm-ext"
#
#  vm_ids              = module.vm.ids
#  script_file_content = {for i in range(length(module.vm.ids)) : element(module.vm.ids, i) => element(data.template_file.setup.*.rendered, i)}
#
#  module_depends_on = [module.disk_attachment]
#
#  tags = var.tesco_tags
#}


module "data_disk" {
  source = "./jumpserver_modules/storage/managed-disk"

  vm_count           = var.vm_count
  resource_group     = var.resource_group_name
  region             = var.location
  vm_name            = local.resource_name
  disk_size_gb       = 32

  module_depends_on = [var.resource_group_name]

  tags = var.tesco_tags
}

module "disk_attachment" {
  source = "./jumpserver_modules/storage/data-disk-attachment"

  disk_ids = module.data_disk.ids
  vm_ids   = module.vm.ids

  module_depends_on = [module.vm, module.data_disk]
}

