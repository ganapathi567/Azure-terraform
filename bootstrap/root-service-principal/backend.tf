terraform {
  backend "azurerm" {
    # place the static variables here
    container_name       = "terraform-state-sts"
    key                  = "terraform.tfstate.rootsp"
  }
}

data "terraform_remote_state" "state" {
  backend = "azurerm"
  config = {
    // duplication required for terraform apply only
    container_name       = "terraform-state-sts"
    key                  = "terraform.tfstate.rootsp"

    // required also for terraform init
    storage_account_name = var.tf_storage_account_name
    resource_group_name  = var.tf_storage_account_resource_group
  }
}
