terraform {
  required_version = "~> 0.14.3"
  required_providers {
    azurerm = ">=2.56.0, < 3.0.0"
    azuread = ">=1.4.0, < 2.0.0"
  }
}

data "azurerm_subscriptions" "team_subscription" {
  display_name_prefix = var.subscription_name
}

locals {
  tenant_id                                    = data.azurerm_subscriptions.team_subscription.subscriptions.0.tenant_id
  shortcodes                                   = split("-", var.subscription_name)
  location                                     = lower(var.location)
  region_shortcode                             = (local.location == "westeurope" ? "euw" : (local.location == "northeurope" ? "eun" : (local.location == "southeastasia" ? "ase" : (local.location == "eastasia" ? "aea" : "unknown"))))
  environment                                  = (var.overwrite_tesco_environment == "" ? (var.tesco_environment == "" ? lower(element(local.shortcodes, 1)) : lower(var.tesco_environment)) : var.overwrite_tesco_environment)
  tesco_team_name                              = lower(var.tesco_team_name)
  team_number                                  = element(local.shortcodes, 0)
  resource_base_name                           = join("-", [local.region_shortcode, local.environment, local.team_number, local.tesco_team_name])
  resource_group_name                          = "${local.resource_base_name}-${var.resource_group_name_suffix}"
  storage_account_name                         = join("", [local.region_shortcode, local.environment, local.team_number, local.tesco_team_name, var.resource_group_name_suffix])
}

data "azuread_group" "contributors" {
  display_name = "AZ-${var.subscription_name}-Contributors"
}

data "azuread_group" "pipeline" {
  display_name = "AZ-${var.subscription_name}-Pipeline"
}

data "azurerm_resource_group" "app_resource_group" {
  name     = "${local.resource_base_name}-${var.resource_group_name_suffix}"
}

data "azuread_service_principal" "appsp" {
  display_name = "${local.resource_base_name}-appsp"
}

resource "azurerm_storage_account" "sts_app_storage" {
  name                     = local.storage_account_name
  resource_group_name      = data.azurerm_resource_group.app_resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = local.all_tags
}

resource "azurerm_role_assignment" "appsp_storage_blob_data_owner_role" {
  scope                = azurerm_storage_account.sts_app_storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azuread_service_principal.appsp.id
}

resource "azurerm_role_assignment" "appsp_storage_contributor_role" {
  scope                = azurerm_storage_account.sts_app_storage.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = data.azuread_service_principal.appsp.id
}