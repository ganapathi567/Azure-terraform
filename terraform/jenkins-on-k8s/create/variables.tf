variable "subscription_name" {
  type        = string
  description = "Subscription name"
}

variable "aks_cluster_name" {
  type        = string
}

variable "aks_cluster_resource_group_name" {
  type        = string
}

variable "aks_principal_id" {
  type        = string
  default = ""
}

variable "keyvault_id" {
  description = "KeyVault ID"
  type        = string
}

variable "keyvault_name" {
  description = "KeyVault name"
  type        = string
}

variable "location" {
  type        = string
  description = "Location of where the resource should be deployed [westeurope, northeurope, southeastasia, eastasia]"
}

variable "tesco_environment" {
  type        = string
  description = "(optional) Overrides the environment name provided by the subscription name (e.g.  dev, prod, rtl, ppe)"
  default     = ""
}

variable "tesco_team_name" {
  type        = string
  description = "Three letter team name (e.g. CPE)"
}

variable "jenkins_base_plugins" {
  description = "Jenkins Base Plugins"
  type        = list(map(string))
  default = [
    {
      name    = "kubernetes"
      version = "1.30.1"
    },
    {
      name    = "workflow-job"
      version = "2.41"
    },
    {
      name    = "workflow-aggregator"
      version = "2.6"
    },
    {
      name    = "git"
      version = "4.5.2"
    },
    {
      name    = "job-dsl"
      version = "1.77"
    },
    {
      name    = "configuration-as-code"
      version = "1.51"
    },
    {
      name    = "kubernetes-credentials-provider"
      version = "0.20"
    },
    {
      name    = "azure-keyvault"
      version = "2.2"
    },
    {
      name    = "github-oauth"
      version = "0.33"
    },
    {
      name    = "matrix-auth"
      version = "2.6.5"
    }
  ]
}

variable "github_client_id" {
  type        = string
  description = "github_client_id"
}

variable "github_client_secret" {
  type        = string
  description = "github_client_secret"
}

variable "github_organization" {
  type        = string
  description = "github_organization"
}

variable "github_team_slug" {
  type        = string
  description = "github_team_slug"
}
