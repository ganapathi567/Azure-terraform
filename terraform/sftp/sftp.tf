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
  resource_name          = join("-", [local.resource_base_name, "sftp"])
  #dns_resource_group     = join("-", [local.region_shortcode, "dns", local.team_number, "sts"])
  #dns_name               = join(".", [local.tesco_team_name, local.environment, local.region_shortcode, "azure.tesco.org"])
  admin_username         = join("-", [local.tesco_team_name, "admin"])
}

resource "azurerm_resource_group" "sftp_resource_group" {
  name                = var.sts_resource_group_name
  location            = var.location

  tags = var.tesco_tags
}


data "azurerm_storage_account" "sftp_storage_account" {
  name                     = var.sftp_storage_account_name 
  resource_group_name      = var.stsapp_resource_group_name 
}

resource "azurerm_storage_container" "store_finalization_container" {
  name                  = var.store_finalization_storage_container_name
  storage_account_name  = data.azurerm_storage_account.sftp_storage_account.name 
  container_access_type = "private"
}

resource "azurerm_storage_container" "bank_statement_container" {
  name                  = var.bank_statement_storage_container_name
  storage_account_name  = data.azurerm_storage_account.sftp_storage_account.name 
  container_access_type = "private"
}

## Step to refer the network resources from existing resource group
data "azurerm_resource_group" "sts_vnet_rg" {
  name = var.networking_resource_group_name
}

##refer to the existing VNET and Subnet
data "azurerm_virtual_network" "sts_vnet" {
  name                = var.networking_learnedroutes_vnet_name
  resource_group_name = var.networking_resource_group_name
}

resource "azurerm_subnet" "sts_sftp_subnet" {
  name                 = var.sftp_subnet
  resource_group_name  = data.azurerm_resource_group.sts_vnet_rg.name
  virtual_network_name = data.azurerm_virtual_network.sts_vnet.name
  address_prefix       = var.sftp_subnet_cidr
}


resource "azurerm_network_security_group" "sftp_subnet_nsg" {
  name                  = local.resource_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.sftp_resource_group.name 

  #security_rule {
  #  name                       = "DenyAllInBound4000"
  #  priority                   = 4000
  #  direction                  = "Inbound"
  #  access                     = "Deny"
  #  protocol                   = "*"
  #  source_port_range          = "*"
  #  destination_port_range     = "*"
  #  source_address_prefix      = "*"
  #  destination_address_prefix = "*"
  #}

  #security_rule {
  #  name                       = "AllowVnetInBound3000"
  #  priority                   = 2500
  #  direction                  = "Inbound"
  #  access                     = "Allow"
  #  protocol                   = "*"
  #  source_port_range          = "*"
  #  destination_port_range     = "22"
  #  source_address_prefix      = "VirtualNetwork"
  #  destination_address_prefix = "*"
  #}

  tags = var.tesco_tags
}

resource "azurerm_subnet_network_security_group_association" "sftp_subnet_nsg" {
  subnet_id                 = azurerm_subnet.sts_sftp_subnet.id
  network_security_group_id = azurerm_network_security_group.sftp_subnet_nsg.id
}

resource "azurerm_subnet_route_table_association" "sftp_subnet_hubinternet" {
  subnet_id      = azurerm_subnet.sts_sftp_subnet.id
  route_table_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.networking_resource_group_name}/providers/Microsoft.Network/routeTables/${var.networking_hubinternet_route_table_name}"
}

#resource "azurerm_public_ip" "sts_sftp_pip" {
#  name                = local.resource_name
#  resource_group_name = azurerm_resource_group.sftp_resource_group.name
#  location            = var.location
#  sku                 = "Standard"
#  allocation_method   = "Static"
#
#  depends_on = [azurerm_resource_group.sftp_resource_group.name]
#  tags = var.tesco_tags
#}

module "sftp_nic" {
  source = "./sftp_modules/compute/nic"

  resource_group_name           = azurerm_resource_group.sftp_resource_group.name
  location                      = var.location
  vm_count                      = var.sftp_vm_count
  vm_name                       = local.resource_name
  subnet_id                     = azurerm_subnet.sts_sftp_subnet.id
  private_ip_address_allocation = "Dynamic"
  #private_ip_address_allocation = "Static"
  #sts_sftp_pip_id 		= azurerm_public_ip.sts_sftp_pip.id

  tags = var.tesco_tags
}

module "sftp_vm" {
  source = "./sftp_modules/compute/vm"

  resource_group_name = azurerm_resource_group.sftp_resource_group.name
  location            = var.location

  availability_zones = var.sftp_availability_zones
  vm_count           = var.sftp_vm_count
  vm_name            = local.resource_name
  vm_size            = var.sftp_vm_size
  nic_ids            = module.sftp_nic.ids
  #sts_sftp_pip_id = azurerm_public_ip.sts_sftp_pip.id
  #script_file_content = {for i in range(length(module.sftp_vm.ids)) : element(module.sftp_vm.ids, i) => element(data.template_file.sftp_setup.*.rendered, i)}

  storage_account_name = data.azurerm_storage_account.sftp_storage_account.name 

  #storage_caching           = "ReadWrite"
  #storage_create_option     = "FromImage"
  #storage_disk_size_gb      = 30
  storage_managed_disk_type = "Premium_LRS"

  admin_username      = var.admin_username
  ssh_public_key_data = var.ssh_public_key_data

#  user_assigned_identity_ids = module.sftp_managed_identity.ids

  module_depends_on = [azurerm_storage_container.store_finalization_container]

  tags = var.tesco_tags
}

module "sftp_vm_ext" {
  source = "./sftp_modules/compute/vm-ext"

  vm_ids              = module.sftp_vm.ids
  script_file_content = {for i in range(length(module.sftp_vm.ids)) : element(module.sftp_vm.ids, i) => element(data.template_file.sftp_setup.*.rendered, i)}

  module_depends_on = [module.sftp_disk_attachment]

  tags = var.tesco_tags
}


module "sftp_data_disk" {
  source = "./sftp_modules/storage/managed-disk"

  vm_count           = var.sftp_vm_count
  resource_group     = azurerm_resource_group.sftp_resource_group.name 
  region             = var.location
  vm_name            = local.resource_name
  availability_zones = var.sftp_availability_zones
  disk_size_gb       = 50

  module_depends_on = [azurerm_resource_group.sftp_resource_group.name]

  tags = var.tesco_tags
}

module "sftp_disk_attachment" {
  source = "./sftp_modules/storage/data-disk-attachment"

  disk_ids = module.sftp_data_disk.ids
  vm_ids   = module.sftp_vm.ids

  module_depends_on = [module.sftp_vm, module.sftp_data_disk]
}

#module "sftp_managed_identity" {
#  source = "./sftp_modules/access/user-managed-identity"
#
#  region              = local.location
#  resource_group_name = azurerm_resource_group.sftp_resource_group.name
#  resource_names      = [local.resource_name]
#
#  tags = var.tesco_tags
#}

#module "sftp_managed_identity_role_assignment" {
#  source = "./sftp_modules/access/role-assignment"
#
#  assignee_principal_id  = module.sftp_managed_identity.principal_ids[0]
#  role_assignment_scopes = [var.installers_storage_account_container_path]
#  role_definition_id     = data.azurerm_role_definition.blob_reader.id
#}
