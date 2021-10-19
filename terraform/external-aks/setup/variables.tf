variable "aks_cluster_name" {
  type        = string
  description = "Azure Kubernetes Service (AKS) cluster name"
  default     = "eun-dev-025-sts-internalaks"
}

variable "aks_cluster_resource_group_name" {
  type        = string
  description = "AKS resource group name"
  default     = "eun-dev-025-sts-internalaks"
}

variable "subscription_name" {
  type        = string
  description = "subscription name"
  default     = "025-DEV-APP-1"
}