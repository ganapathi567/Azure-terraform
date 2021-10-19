module "application-gateway" {
  source = "git@github.dev.global.tesco.org:TescoSharedPlatform/terraform-azure-application-gateway.git?ref=0.9.0"

  tesco_environment = var.tesco_environment
  tesco_team_name   = var.tesco_team_name
  subscription_name = var.subscription_name
  location          = var.location

  aks_service_account_object_id        = var.aks_principal_id
  application_gateway_subnet_cidr      = var.appgw_subnet_cidr
  //existing_subnet_name                 = var.existing_subnet_name
  networking_resource_group_name       = var.networking_resource_group_name
  networking_azdefaultroutes_vnet_name = var.networking_azdefaultroutes_vnet_name

  application_gateway_sku_name = "Standard_v2"
  application_gateway_sku_tier = "Standard_v2"
}