variable "subscription_name" {
  type        = string
  description = "Name of the subscription (e.g. 169-DEV-APP-1)"
  validation {
    condition     = can(regex("^(?:\\d{3})-(?:PROD|DEV|RTL)-(?:APP|SCS|HUB|SEC|TSP)-(?:\\d+)$", var.subscription_name))
    error_message = "Subscription name has to meet following name convention <tno>-<env>-<ara>-<number>.\nCheck https://github.dev.global.tesco.org/Cloud/Wiki/wiki/Naming-Standards ."
  }
}
variable "resource_group_name_suffix" {
  type        = string
  description = "Suffix for created resource group"
  default     = "app"
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.resource_group_name_suffix))
    error_message = "Suffix has to be combination of lower letter or number."
  }
}

variable "tesco_environment" {
  type        = string
  description = "(optional) Overrides the environment name provided by the subscription name (e.g.  dev, prod, rtl, ppe)"
  default     = ""
  validation {
    condition     = can(regex("^(?:|prod|dev|rtl|ppe)$", var.tesco_environment))
    error_message = "Allowed values: poc, prod, dev, rtl, ppe."
  }
}

variable "overwrite_tesco_environment" {
  type        = string
  description = "(optional) Overrides tesco_environment variable and allows to environment name to be 3-4 chars. NOTE: Using this variable may cause side effects."
  default     = ""
  validation {
    condition     = can(regex("^(?:|[a-z0-9]{3,4})$", var.overwrite_tesco_environment))
    error_message = "Environment overrides has to be 3 or 4 lower letter or number combination."
  }
}

variable "tesco_team_name" {
  type        = string
  description = "3 to 8 lower letter or number combination team name (e.g. CPE)"
  validation {
    condition     = can(regex("^[a-z0-9]{3,8}$", var.tesco_team_name))
    error_message = "Team name has to be 3 to 8 lower letter or number combination."
  }
}

variable "location" {
  type        = string
  description = "Location of where the resource should be deployed [westeurope, northeurope, southeastasia, eastasia]"
  validation {
    condition     = can(regex("^(?:westeurope|northeurope|southeastasia|eastasia)$", var.location))
    error_message = "Allowed values: westeurope, northeurope, southeastasia, eastasia."
  }
}

variable "key_vault_name_suffix" {
  type        = string
  description = "Suffix for created Key Vault name"
  default     = "app"
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.key_vault_name_suffix))
    error_message = "Key Vault suffix  name has to be combination of lower letter or number."
  }
}

variable "key_vault_contact_emails" {
  type        = list(string)
  description = "Email addresses for notifications related to certificate operations (e.g. certificate expiration). See Azure docs: https://docs.microsoft.com/en-us/azure/key-vault/certificates/about-certificates#certificate-contacts"
  default     = []
}

variable "contributors_group_policies_permissions" {
  type        = map(list(string))
  description = "The key permissions for the contributors group policy"
  default = {
    key_permissions         = ["get", "list", "create", "restore", "encrypt", "decrypt", "verify"],
    secret_permissions      = ["get", "list", "set", "restore"],
    certificate_permissions = ["get", "list", "update", "create", "import", "restore", "getissuers", "listissuers"]
  }
}

variable "pipeline_group_policies_permissions" {
  type        = map(list(string))
  description = "The key permissions for the contributors group policy"
  default = {
    key_permissions         = ["get", "list", "update", "create", "import", "delete", "recover", "backup", "restore", "decrypt", "encrypt", "unwrapKey", "wrapKey", "sign", "verify"],
    secret_permissions      = ["get", "list", "set", "delete", "recover", "backup", "restore"],
    certificate_permissions = ["get", "list", "update", "create", "import", "delete", "recover", "backup", "restore", "managecontacts", "getissuers", "listissuers"]
  }
}

variable "tags" {
  type        = map(string)
  description = "User defined extra tags to be added to all resources created in the module"
  default     = {}
}
