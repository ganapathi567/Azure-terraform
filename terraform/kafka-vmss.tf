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
  storage_account_name   = join("", [local.region_shortcode, local.environment, local.team_number, local.tesco_team_name, "kafka"])
  storage_contianer_name = join("-", [local.environment, local.tesco_team_name, "kafka"]) 
  resource_name          = join("-", [local.resource_base_name, "kafka"])
  #dns_resource_group     = join("-", [local.region_shortcode, "dns", local.team_number, "sts"])
  #dns_name               = join(".", [local.tesco_team_name, local.environment, local.region_shortcode, "azure.tesco.org"])
  admin_username         = join("-", [local.tesco_team_name, "admin"])
}

resource "azurerm_resource_group" "kafka_resource_group" {
  name     = var.kafka_resource_group_name
  location = var.location

  tags = var.tesco_tags
}

resource "azurerm_storage_account" "kafka_storage_account" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.kafka_resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tesco_tags
}

resource "azurerm_storage_container" "kafka_storage_container" {
  name                  = local.storage_contianer_name
  storage_account_name  = azurerm_storage_account.kafka_storage_account.name
  container_access_type = "private"
}

## Step to refer the network resources from existing resource group
data "azurerm_resource_group" "sts_kafka_vnet_rg" {
  name = var.networking_resource_group_name
}

##refer to the existing VNET and Subnet
data "azurerm_virtual_network" "sts_kafka_vnet" {
  name                = var.networking_learnedroutes_vnet_name
  resource_group_name = var.networking_resource_group_name
}

resource "azurerm_subnet" "sts_kafka_subnet" {
  name                 = var.kafka_subnet
  resource_group_name  = var.networking_resource_group_name 
  virtual_network_name = var.networking_learnedroutes_vnet_name
  address_prefix       = var.kafka_subnet_cidr
}


#resource "azurerm_route_table" "kafka_route_table" {
#  name                = local.resource_name
#  location            = var.location
#  resource_group_name = azurerm_resource_group.kafka_resource_group.name
#  
#  tags = var.tesco_tags
#}

resource "azurerm_subnet_route_table_association" "kafka_subnet_hubinternet" {
  subnet_id      = azurerm_subnet.sts_kafka_subnet.id
  route_table_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.networking_resource_group_name}/providers/Microsoft.Network/routeTables/${var.networking_hubinternet_route_table_name}"
}

resource "azurerm_network_security_group" "kafka_subnet_nsg" {
  name                  = local.resource_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.kafka_resource_group.name

#  security_rule {
#    name                       = "DenyAllInBound4000"
#    priority                   = 4000
#    direction                  = "Inbound"
#    access                     = "Deny"
#    protocol                   = "*"
#    source_port_range          = "*"
#    destination_port_range     = "*"
#    source_address_prefix      = "*"
#    destination_address_prefix = "*"
#  }
#
#  security_rule {
#    name                       = "AllowVnetInBound3000"
#    priority                   = 2500
#    direction                  = "Inbound"
#    access                     = "Allow"
#    protocol                   = "*"
#    source_port_range          = "*"
#    destination_port_range     = "22"
#    source_address_prefix      = "VirtualNetwork"
#    destination_address_prefix = "*"
#  }

  tags = var.tesco_tags
}

resource "azurerm_subnet_network_security_group_association" "kafka_subnet_nsg" {
  subnet_id                 = azurerm_subnet.sts_kafka_subnet.id
  network_security_group_id = azurerm_network_security_group.kafka_subnet_nsg.id
}

module "kafka_vmss" {
  source = "./kafka_modules/compute/vmss"
  kafka_resource_group_name  = azurerm_resource_group.kafka_resource_group.name 
  resource_name              = local.resource_name
  location                   = var.location
  kafka_subnet_id            = azurerm_subnet.sts_kafka_subnet.id
  vmss_size                  = var.kafka_vm_size
  vmss_count                 = var.kafka_broker_count
  admin_username             = var.admin_username
  #script_file_content        = data.template_file.kafka_broker_installation.*.rendered
  #script_file_content        = {for i in range(length(module.kafka_vmss.id)) : element(module.kafka_vmss.id, i) => element(data.template_file.kafka_broker_installation.*.rendered, i)}
  ssh_public_key_data        = var.ssh_public_key_data
  datadisk_size              = var.datadisk_size
  storage_account_name       = azurerm_storage_account.kafka_storage_account.name
  #user_assigned_identity_ids = module.kafka_managed_identity.ids

  module_depends_on          = [azurerm_subnet.sts_kafka_subnet.id, azurerm_storage_account.kafka_storage_account.name, azurerm_storage_container.kafka_storage_container]
  tags                       = var.tesco_tags
}

module "kafka_vmss_ext" {
  source = "./kafka_modules/compute/vmss-ext"

  resource_name       = local.resource_name
  vmss_id             = module.kafka_vmss.id
  #script_file_content = data.template_file.kafka_broker_installation.*.rendered
  script_file_content = {for i in range(length(module.kafka_vmss.id)) : element(module.kafka_vmss.id, i) => element(data.template_file.kafka_broker_installation.*.rendered, i)}

  module_depends_on   = [module.kafka_vmss]
}

module "kafka_vmss_autoscale" {
  source = "./kafka_modules/compute/vmss-autoscale"

  resource_name         = local.resource_name
  kafka_resource_group_name  = azurerm_resource_group.kafka_resource_group.name
  vmss_id                 = module.kafka_vmss.id
  location              = var.location
  vmss_sku_min_capacity = var.kafka_min_node_count
  vmss_sku_max_capacity = var.kafka_max_node_count
  notify_email          = var.notify_email

  module_depends_on = [module.kafka_vmss]
  tags              = var.tesco_tags
}
#module "kafka_managed_identity" {
#  source = "./kafka_modules/access/user-managed-identity"
#
#  region              = local.location
#  resource_group_name = azurerm_resource_group.kafka_resource_group.name.name.name
#  resource_names      = [local.resource_name]
#
#  tags = var.tesco_tags
#}

#module "kafka_managed_identity_role_assignment" {
#  source = "./kafka_modules/access/role-assignment"
#
#  assignee_principal_id  = module.kafka_managed_identity.principal_ids[0]
#  role_assignment_scopes = [var.installers_storage_account_container_path]
#  role_definition_id     = data.azurerm_role_definition.blob_reader.id
#}

##Step to refer the existing pdns resource group
data "azurerm_resource_group" "sts_kafka_pdns_rg" {
  name = var.sts_pdns_resource_group_name
}

##Step to refer the existing pdns zone
#data "azurerm_private_dns_zone" "sts_pdns_zone" {
#  name                = var.sts_pdns_zone_name
#  resource_group_name = data.azurerm_resource_group.sts_kafka_pdns_rg.name
#}

data "external" "vmssips" {
  program = ["bash", "./getVmssIps1.sh"]
  query = {
    resGrp = var.kafka_resource_group_name
    vmssName = local.resource_name
  }
}

resource "azurerm_private_dns_a_record" "kafka_dns_zone_a_record" {
  count               = var.kafka_broker_count
  name                = "kafka-${count.index + 1}"
  zone_name           = var.sts_pdns_zone_name
  resource_group_name = data.azurerm_resource_group.sts_kafka_pdns_rg.name
  ttl                 = 300
  records             = [element(split(",", data.external.vmssips.result.myVmssIps), count.index)]
}


module "appdynamics" {
  source = "./kafka_modules/monitoring/appdynamics"

  service_name                  = "kafka"
  service_process_monitor_type  = "regex"
  service_process_monitor_value = ".* kafka.Kafka .*"

  appdynamics_access_key      = var.appdynamics_access_key
  appdynamics_account         = var.appdynamics_account
  appdynamics_controller_host = var.appdynamics_controller_host
  installers_storage_account  = var.installers_storage_account

  subscription_id   = var.subscription_id
  tesco_environment = local.environment
  tesco_team_name   = local.tesco_team_name
}
