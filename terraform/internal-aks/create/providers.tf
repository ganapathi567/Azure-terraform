terraform {
  required_version = "~> 0.14.3"
  required_providers {
    azurerm = ">=2.14.0, < 3.0.0"
    azuread = ">=1.0.0, < 2.0.0"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

provider "azuread" {
  version = ">=1.0.0,<2.0.0"
}



