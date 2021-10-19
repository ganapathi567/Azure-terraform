module "global" {
  source = "git@github.dev.global.tesco.org:TescoSharedPlatform/terraform-azure-global.git?ref=0.7.0"

  subscription_name = var.subscription_name
  location          = var.location
  tesco_team_name   = var.tesco_team_name
  tesco_environment = var.tesco_environment
}