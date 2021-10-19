provider "azurerm" {
 version = "=2.1.0"
  features {}
subscription_id = var.subscription_id
tenant_id = var.tenant_id
}

#data "azurerm_subscriptions" "team_subscription" {
#  display_name_prefix = var.subscription_name
#}

locals {
  subscription_id        = var.subscription_id
  shortcodes             = split("-", var.subscription_name)
  location               = lower(var.location)
  region_shortcode       = (local.location == "westeurope" ? "euw" : (local.location == "northeurope" ? "eun" : (local.location == "southeastasia" ? "ase" : (local.location == "eastasia" ? "aea" : "unknown"))))
  environment            = (var.tesco_environment == "" ? lower(element(local.shortcodes, 1)) : lower(var.tesco_environment))
  tesco_team_name        = lower(var.tesco_team_name)
  team_number            = element(local.shortcodes, 0)
  resource_base_name     = join("-", [local.region_shortcode, local.environment, local.team_number, local.tesco_team_name])
  storage_account_name   = join("", [local.region_shortcode, local.environment, local.team_number, local.tesco_team_name, "mongo"])
  storage_container_name = join("-", [local.environment, local.tesco_team_name, "mongo-uk"])
  storage_container_backup_name = join("-", [local.environment, local.tesco_team_name, "mongo-uk-backup"])
  resource_name          = join("-", [local.resource_base_name, "mongo-shard-uk"])
  dns_resource_group     = join("-", [local.region_shortcode, local.environment, local.team_number, local.tesco_team_name, "pdns"])
  dns_name               = join(".", [local.tesco_team_name, local.environment, local.region_shortcode, "azure.tesco.org"])
  replica_set_name       = join("-", [local.tesco_team_name, "mongo-shard-uk"])
  key_file_path          = "/etc/mongo-key.key"
  admin_username         = join("-", [local.tesco_team_name, "admin"])
}


resource "azurerm_resource_group" "mongo_resource_group" {
  name                = "${local.resource_base_name}-mongo"
  location            = var.location

  tags = var.tesco_tags
}

resource "azurerm_resource_group" "jumbox_resource_group" {
  name                = var.jumpserver_name_rg
  location            = var.location

  tags = var.tesco_tags
}

#resource "azurerm_resource_group" "mongo_pdns_rg" {
#  name                = var.mongo_pdns_resource_group_name
#  location            = var.location
#
#  tags = var.tesco_tags
#}

##Step to refer the existing resource group
data "azurerm_resource_group" "mongo_resource_group" {
  name = var.mongo_resource_group_name
}

##Step to refer the existing pdns resource group
#data "azurerm_resource_group" "sts_mongo_pdns_rg" {
#  name = var.mongo_pdns_resource_group_name
#}


## Step to refer the network resources from existing resource group
data "azurerm_resource_group" "sts_mongo_vnet_rg" {
  name = var.networking_resource_group_name
}

##refer to the existing VNET and Subnet
data "azurerm_virtual_network" "sts_mongo_vnet" {
  name                = var.networking_learnedroutes_vnet_name
  resource_group_name = var.networking_resource_group_name
}

data "azurerm_subnet" "mongo_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.networking_resource_group_name
  virtual_network_name = var.networking_learnedroutes_vnet_name
}

resource "azurerm_subnet" "mongo_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.networking_resource_group_name
  virtual_network_name = var.networking_learnedroutes_vnet_name
  address_prefix       = var.mongo_subnet_cidr
}

#resource "azurerm_route_table" "mongo_route_table" {
#  name                = var.networking_hubinternet_route_table_name 
#  location            = var.location
#  resource_group_name = var.networking_resource_group_name
#}

resource "azurerm_network_security_group" "mongo_subnet_nsg" {
  name                  = var.mongo_subnet_nsg 
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.mongo_resource_group.name 

  security_rule {
    name                       = "DenyAllInBound4000"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ssh_port"
    priority                   = 3000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "mongo_port"
    priority                   = 2600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "27017"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  tags = var.tesco_tags
}

resource "azurerm_subnet_network_security_group_association" "mongo_subnet_nsg" {
  subnet_id                 = data.azurerm_subnet.mongo_subnet.id
  network_security_group_id = azurerm_network_security_group.mongo_subnet_nsg.id
}

resource "azurerm_subnet_route_table_association" "mongo_subnet_hubinternet" {
  subnet_id      = data.azurerm_subnet.mongo_subnet.id
  route_table_id = "/subscriptions/${local.subscription_id}/resourceGroups/${var.networking_resource_group_name}/providers/Microsoft.Network/routeTables/${var.networking_hubinternet_route_table_name}"
}

resource "azurerm_storage_account" "mongo_storage_account" {
  name                     = local.storage_account_name
  resource_group_name      = data.azurerm_resource_group.mongo_resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tesco_tags
}

resource "azurerm_storage_container" "mongo_storage_container" {
  name                  =  local.storage_container_name
  storage_account_name  =  azurerm_storage_account.mongo_storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "mongo_storage_container_backups" {
  name                  = local.storage_container_backup_name
  storage_account_name  = azurerm_storage_account.mongo_storage_account.name
  container_access_type = "private"
}

module "mongo_vmss" {
  source = "../mongo_modules/compute/vmss"
  mongo_resource_group_name  = data.azurerm_resource_group.mongo_resource_group.name
  resource_name              = local.resource_name
  location                   = var.location
  mongo_subnet_id            = data.azurerm_subnet.mongo_subnet.id 
  vmss_size                  = var.mongo_vm_size
  vmss_count                 = var.mongo_node_count
  admin_username             = var.admin_username
  script_file_content        = data.template_file.mongo_installation.rendered
  ssh_public_key_data        = var.ssh_public_key_data
  datadisk_size              = var.datadisk_size
  storage_account_name       = azurerm_storage_account.mongo_storage_account.name
  #user_assigned_identity_ids = module.mongo_uk_shard_managed_identity.ids
  
  module_depends_on          = [data.azurerm_subnet.mongo_subnet.id, azurerm_storage_account.mongo_storage_account.name, azurerm_storage_container.mongo_storage_container]
  tags                       = var.tesco_tags
}

module "mongo_vmss_ext" {
  source = "../mongo_modules/compute/vmss-ext"

  resource_name       = local.resource_name
  vmss_id               = module.mongo_vmss.id
  script_file_content = data.template_file.mongo_installation.rendered

  module_depends_on   = [module.mongo_vmss]
}

module "mongo_vmss_autoscale" {
  source = "../mongo_modules/compute/vmss-autoscale"

  resource_name         = local.resource_name
  mongo_resource_group_name  = data.azurerm_resource_group.mongo_resource_group.name
  vmss_id                 = module.mongo_vmss.id
  location              = var.location
  vmss_sku_min_capacity = var.mongo_min_node_count
  vmss_sku_max_capacity = var.mongo_max_node_count
  notify_email          = var.notify_email

  module_depends_on = [module.mongo_vmss]
  tags              = var.tesco_tags
}

#module "mongo_uk_shard_managed_identity" {
#  source = "../mongo_modules/access/user-managed-identity"

#  region              = local.location
#  resource_group_name = data.azurerm_resource_group.mongo_resource_group.name 
#  resource_names      = [local.resource_name]

#  tags = var.tesco_tags
#}

#module "mongo_uk_shard_managed_identity_role_assignment" {
#  source = "../mongo_modules/access/role-assignment"

#  assignee_principal_id  = module.mongo_uk_shard_managed_identity.principal_ids[0]
#  role_assignment_scopes = [local.storage_container_name]
#  role_definition_id     = data.azurerm_role_definition.blob_reader.id
#}

#module "mongo_uk_shard_managed_identity_role_assignment_backups" {
#  source = "../mongo_modules/access/role-assignment"

#  assignee_principal_id  = module.mongo_uk_shard_managed_identity.principal_ids[0]
#  role_assignment_scopes = [local.storage_container_backup_name]
#  role_definition_id     = data.azurerm_role_definition.blob_contributor.id

#  module_depends_on = [azurerm_storage_container.mongo_storage_container_backups]
#}

#resource "azurerm_private_dns_zone" "sts_ppe_mongo_pdns" {
#  name                = var.mongo_zone_name
#  resource_group_name = data.azurerm_resource_group.sts_mongo_pdns_rg.name
#}

data "external" "vmssips" {
  program = ["bash", "./getVmssIps1.sh"]
  query = {
    resGrp = var.mongo_resource_group_name
    vmssName = local.resource_name
  }
}

resource "azurerm_private_dns_a_record" "mongo_dns_zone_a_record" {
  count               = var.mongo_node_count
  name                = "mongo-shard-uk${count.index + 1}"
  zone_name           = var.mongo_zone_name
  resource_group_name = var.mongo_pdns_resource_group_name 
  ttl                 = 300
  records             = [element(split(",", data.external.vmssips.result.myVmssIps), count.index)]
}

module "appdynamics" {
  source = "../mongo_modules/monitoring/appdynamics"

  service_name                  = "mongo-uk-shard"
  service_process_monitor_value = "/var/run/mongodb/mongod.pid"

  appdynamics_access_key      = var.appdynamics_access_key
  appdynamics_account         = var.appdynamics_account
  appdynamics_controller_host = var.appdynamics_controller_host
  installers_storage_account  = var.installers_storage_account

  subscription_id   = var.subscription_id
  tesco_environment = local.environment
  tesco_team_name   = local.tesco_team_name
}

module "splunk" {
  source = "../mongo_modules/logging/splunk"

  service_name = "mongo-uk-shard"
  monitors     = ["/var/log/mongodb/backup"]

  index                      = var.splunk_index
  installers_storage_account = var.installers_storage_account

  subscription_id   = var.subscription_id
  tesco_environment = local.environment
  tesco_team_name   = local.tesco_team_name
  tesco_team_number = local.team_number
}

module "mongo_uk_shard_backup" {
  source = "../mongo_modules/backup"

  service_name    = "mongo-uk-shard"
  storage_account = var.mongo_storage_account_name
  log_path        = "/var/log/mongodb/backup"

  service_backup_script = templatefile("./templates/backup.sh", {
    username = local.admin_username
    password = random_password.mongo_admin_password.result
  })

  subscription_id   = var.subscription_id
  tesco_environment = local.environment
  tesco_team_name   = local.tesco_team_name
}
