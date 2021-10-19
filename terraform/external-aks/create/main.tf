locals {
  networking_base_name  = var.networking_base_name

  # VNET Networking resources still use the FRS team name
  networking_learnedroutes_vnet_name      = "${local.networking_base_name}-learnedroutes"
  networking_azdefaultroutes_vnet_name    = "${local.networking_base_name}-${var.az_prefix}defaultroutes"
  networking_hubinternet_route_table_name = "${local.networking_base_name}-hubinternet"
  networking_resource_group_name          = "${local.networking_base_name}-net"
}

module "ad" {
  source = "git@github.dev.global.tesco.org:TescoSharedPlatform/terraform-azure-ad-sp.git?ref=0.4.0"

  owner_object_ids       = var.owner_object_ids
  service_principal_name = var.service_principal_name
  type                   = "basic"
}

module "aks-create" {
  source = "git@github.dev.global.tesco.org:TescoSharedPlatform/terraform-azure-aks.git//submodules/create?ref=0.11.0"

  tesco_environment = var.tesco_environment
  tesco_team_name   = var.tesco_team_name
  subscription_name = var.subscription_name
  location          = var.location

  aks_name_suffix                 = var.aks_name_suffix
  resource_group_name_suffix      = var.resource_group_name_suffix
  aks_subnet_name_suffix          = var.aks_subnet_name_suffix
  aks_agent_count                 = var.aks_agent_count
  aks_node_count_min              = var.aks_node_count_min
  aks_node_count_max              = var.aks_node_count_max
  aks_subnet_cidrs                = var.aks_subnet_cidrs
  aks_subnet_service_endpoints    = var.aks_subnet_service_endpoints
  aks_network_plugin              = var.aks_network_plugin
  aks_pod_cidr                    = var.aks_network_plugin == "kubenet" ? var.aks_pod_cidr : null
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  kubernetes_version              = var.kubernetes_version
  enable_nightly_auto_shutdown    = var.enable_nightly_auto_shutdown
  regular_node_pools              = var.regular_node_pools
  aks_enable_auto_scaling         = var.aks_enable_auto_scaling
  azure_active_directory_managed  = true

  networking_hubinternet_route_table_name                   = local.networking_hubinternet_route_table_name
  networking_resource_group_name                            = local.networking_resource_group_name
  networking_learnedroutes_vnet_name                        = local.networking_learnedroutes_vnet_name
  networking_azdefaultroutes_vnet_name                      = local.networking_azdefaultroutes_vnet_name

  sp_client_id     = module.ad.client_id
  sp_client_secret = module.ad.client_secret
  sp_principal_id  = module.ad.principal_id
}