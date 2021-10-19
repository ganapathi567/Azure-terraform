module "global" {
  source = "git@github.dev.global.tesco.org:TescoSharedPlatform/terraform-azure-global.git?ref=0.8.0"

  subscription_name = var.subscription_name
  location          = var.location
  tesco_team_name   = var.tesco_team_name
  tesco_environment = var.tesco_environment

  enable_key_vault          = true
  enable_container_registry = true

  container_registry_sku                       = "Premium"
  container_registry_geo_replication_locations = ["West Europe"] # <---- Only additional locations. Cannot contain var.location value
  resource_group_name_suffix = var.resource_group_name_suffix
}