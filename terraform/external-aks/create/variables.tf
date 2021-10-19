variable "owner_object_ids" {
  type        = list(string)
  description = "The object ids of a service principal or user that should be the owner of the created AD resources"
}

variable "service_principal_name" {
  type = string
}

variable "subscription_name" {
  type        = string
  description = "Subscription name"
}

variable "tesco_environment" {
  type        = string
  description = "Environment"
}

variable "tesco_team_name" {
  type        = string
  description = "Team name"
}

variable "location" {
  type        = string
  description = "Location"
}

variable "kubernetes_version" {
  description = "Version of Kubernetes specified when creating the AKS managed cluster"
  default     = "1.16.13"
}

variable "aks_name_suffix" {
  type        = string
  description = "Azure Kubernetes Service (AKS) name suffix"
  default     = "aks"
}

variable "resource_group_name_suffix" {
  type        = string
  description = "Suffix for created resource group"
  default     = "aks"
}

variable "aks_subnet_name_suffix" {
  type        = string
  description = "The AKS subnet name suffix"
  default     = "application"
}

variable "aks_network_plugin" {
  type        = string
  description = "Azure Kubernetes Service (AKS) network plugin"
  default     = "azure"
}

variable "aks_pod_cidr" {
  type        = string
  description = "CIDR allocated for Kubernetes Pods (only makes sense when aks_network_plugin is kubenet)"
}

variable "aks_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDRs for AKS cluster, e.g. [\"10.118.2.0/26\"]"
}

variable "aks_subnet_service_endpoints" {
  type        = list(string)
  description = "Allow access from subnet to service endpoints from the list."
}

variable "aks_agent_count" {
  type        = number
  description = "Number of workers in the agent pool"
  default     = 3
}

variable "aks_enable_auto_scaling" {
  type        = bool
  description = "enable auto scaling, max_count(4) and min_count(3) must be set to null` when enable_auto_scaling is set to false"
  default     = false
}

variable "aks_node_count_min" {
  type        = number
  description = "Min number of nodes in the agent pool"
  default     = null
}

variable "aks_node_count_max" {
  type        = number
  description = "Max number of nodes in the agent pool"
  default     = null
}

variable "api_server_authorized_ip_ranges" {
  type        = list(string)
  description = "Authorized IP ranges to access k8s API"
  default     = []
}

variable "enable_nightly_auto_shutdown" {
  type        = bool
  description = "Enable scheduler for cluster shutdown during non working hours"
  default     = false
}

variable "networking_base_name" {
  type        = string
  description = "Networking base name"
  default     = "eun-dev-025-frs"
}

variable "az_prefix" {
  type        = string
  description = "The prefix of az before the defaults route vnet name."
  default     = ""
}

variable "regular_node_pools" {
  type = list(object({
    name                = string
    os_disk_size_gb     = number
    vm_size             = string
    max_count           = number
    min_count           = number
    node_count          = number
    max_pods            = number
    availability_zones  = list(number)
    enable_auto_scaling = bool
    node_taints         = list(string)
    mode                = string
    node_labels         = map(string)
    kubernetes_version  = string
  }))
  description = "User-defined node pools of Regular priority"
  default     = []
}

