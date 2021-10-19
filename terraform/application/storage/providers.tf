# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

provider "azuread" {
  version = ">=1.0.0,<2.0.0"
}



