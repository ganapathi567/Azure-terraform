variable "subscription_name" {
  type        = string
  description = "Name of the subscription (e.g. 025-DEV-APP-1)"
  default     = "025-PROD-APP-1"
}

variable "tesco_team_name" {
  type        = string
  description = "Three letter team name (e.g. STS)"
  default     = "sts"
}

variable "tesco_environment" {
  type        = string
  description = "Name of the environment"
  default     = "ppe"
}

variable "location" {
  type        = string
  description = "Location"
  default     = "northeurope"
}

variable "tesco_tags" {
  type = map(string)
  default     = {}
}

variable "admin_username" {
  type        = string
  description = "admin_user name"
  default     = "sts-admin"
}

variable "ssh_public_key_data" {
  type        = string
  description = "ssh_public_key_data"
  default     = "var.ssh_public_key_data"
}

variable "networking_resource_group_name" {
  type        = string
  description = "Networking resource group name"
}

variable "networking_learnedroutes_vnet_name" {
  type        = string
  description = "Networking learnedroutes VNET name"
}

variable "networking_hubinternet_route_table_name" {
  type        = string
  description = "Networking hub to internet route table name"
}

variable "kafka_subnet_cidr" {
  type        = string
  description = "subnet_cidr"
}


variable "kafka_vm_size" {
  type        = string
  description = "instance type"
  default     = "Standard_D4s_v3"
}

variable "kafka_broker_count" {
  type        = number
  description = "Number of nodes"
  default     = "3"
}

variable "kafka_availability_zones" {
  type        = list(number)
  description = "Availability zones"
  default     = ["1", "2", "3"]
}

variable "kafka_partitions" {
  type        = number
  description = "Kafka partitions"
  default     = "8"
}

#variable "zookeeper_node_count" {}


variable "installers_storage_account" {
  type        = string
  description = "installers_storage_account"
  default     = ""
}
  
variable "installers_storage_account_container_path" {
  type    = string
  description = "installers_storage_account_container_path"
  default     = ""
}

variable "appdynamics_controller_host" {
  type        = string
  description = "appdynamics_controller_host"
  default     = ""
}

variable "appdynamics_account" {
  type        = string
  description = "appdynamics_account"
  default     = ""
}

variable "appdynamics_access_key" {
  type        = string
  description = "appdynamics_access_key"
  default     = ""
}

variable "tenant_id" {
  type        = string
  description = "tenant_id"
  default     = "f55b1f7d-7a7f-49e4-9b90-55218aad89f8"
}

variable "subscription_id" {
  type        = string
  description = "subscription_id"
}

variable "sts_pdns_resource_group_name" {
  type        = string
  description = "pdns_resource_group_name"
}


variable "kafka_storage_account_name" {
  type    = string
  description = "kafka_storage_account_name"
}

variable "kafka_resource_group_name" {
  type    = string
  description = "kafka_resource_group_name"
}


variable "sts_pdns_zone_name" { 
  type        = string
  description = "pdns__zone_name"
}

variable "kafka_min_node_count" {
  type        = string
  description = "min count of nodes"
}

variable "kafka_max_node_count" {
  type        = string
  description = "max count of nodes"
}

variable "resource_name" {
  type        = string
  description = "name of resources"
}

variable "kafka_subnet" {
  type        = string
  description = "name of subnet"
}

variable "datadisk_size" {
  type = number
  default = 250
}

variable "notify_email" {
  default = "32fbe1bd.tesco.onmicrosoft.com@emea.teams.ms"
  description = "notify_teams channel"
}
