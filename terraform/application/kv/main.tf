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
}

data "azuread_group" "contributors" {
  display_name = "AZ-${var.subscription_name}-Contributors"
}

data "azuread_group" "pipeline" {
  display_name = "AZ-${var.subscription_name}-Pipeline"
}

data "azuread_service_principal" "appsp" {
  display_name = "${local.resource_base_name}-appsp"
}

resource "azurerm_resource_group" "app_resource_group" {
  name     = "${local.resource_base_name}-${var.resource_group_name_suffix}"
  location = var.location

  tags = local.all_tags
}

resource "azurerm_key_vault" "app_key_vault" {
  name                = "${local.resource_base_name}-${var.key_vault_name_suffix}"
  resource_group_name = azurerm_resource_group.app_resource_group.name
  location            = var.location
  tenant_id           = local.tenant_id
  sku_name            = "standard"

  dynamic "contact" {
    for_each = var.key_vault_contact_emails
    content {
      email = contact.value
    }
  }

  tags = local.all_tags

  depends_on = [azurerm_resource_group.app_resource_group]
}

resource "azurerm_key_vault_access_policy" "contributors_group_policies" {
  key_vault_id = azurerm_key_vault.app_key_vault.id

  tenant_id = local.tenant_id
  object_id = data.azuread_group.contributors.id

  key_permissions         = var.contributors_group_policies_permissions.key_permissions
  secret_permissions      = var.contributors_group_policies_permissions.secret_permissions
  certificate_permissions = var.contributors_group_policies_permissions.certificate_permissions

  depends_on = [azurerm_key_vault.app_key_vault]
}

resource "azurerm_key_vault_access_policy" "pipeline_group_policies" {
  key_vault_id = azurerm_key_vault.app_key_vault.id

  tenant_id = local.tenant_id
  object_id = data.azuread_group.pipeline.id

  key_permissions         = var.pipeline_group_policies_permissions.key_permissions
  secret_permissions      = var.pipeline_group_policies_permissions.secret_permissions
  certificate_permissions = var.pipeline_group_policies_permissions.certificate_permissions

  depends_on = [azurerm_key_vault.app_key_vault]
}

resource "azurerm_key_vault_access_policy" "appsp_policies" {
  key_vault_id = azurerm_key_vault.app_key_vault.id

  tenant_id = local.tenant_id
  object_id = data.azuread_service_principal.appsp.object_id

  key_permissions         = var.appsp_policies_permissions.key_permissions

  depends_on = [azurerm_key_vault.app_key_vault]
}

resource "azurerm_key_vault_key" "c2cAliasKey" {
  name         = "C2CIngestionKeyAlias"
  key_vault_id = azurerm_key_vault.app_key_vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}
