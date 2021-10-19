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

variable "appgw_subnet_cidr" {
  type        = string
  description = "appgw_subnet_cidr"
}

variable "networking_resource_group_name" {
  type        = string
  description = "networking_resource_group_name"
}

variable "networking_azdefaultroutes_vnet_name" {
  type        = string
  description = "networking_azdefaultroutes_vnet_name"
}
