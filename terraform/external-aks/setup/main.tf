module "aks-setup" {
  source = "git@github.dev.global.tesco.org:TescoSharedPlatform/terraform-azure-aks.git//submodules/setup?ref=0.10.0"

  subscription_name = var.subscription_name
}