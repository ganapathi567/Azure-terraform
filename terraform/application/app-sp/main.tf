module "ad" {
  source = "git@github.dev.global.tesco.org:TescoSharedPlatform/terraform-azure-ad-sp.git?ref=0.4.0"

  owner_object_ids = var.owner_object_ids
  service_principal_name = var.app_service_principal_name
  type = "basic"
}
