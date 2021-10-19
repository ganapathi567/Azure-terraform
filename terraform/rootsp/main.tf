module "ad" {
  source = "git@github.dev.global.tesco.org:TescoSharedPlatform/terraform-azure-ad-sp.git?ref=0.4.0"

  owner_object_ids = [
    "25771ac6-e4bf-42f3-8fc7-44851671bf8a",
    "96bf77e5-7920-4383-8880-a830db3a186f",
    "d2d419f4-9ef3-4ce2-a81b-44d9e755605c"
  ]

  service_principal_name = var.root_service_principal_name
  type = "root"
}
