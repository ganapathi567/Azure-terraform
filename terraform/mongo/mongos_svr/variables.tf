variable "subscription_name" {
  type        = string
  description = "Name of the subscription"
}

variable "tesco_team_name" {
  type        = string
  description = "Three letter team name (e.g. STS)"
  default     = "sts"
}

variable "tesco_environment" {
  type        = string
  description = "Name of the environment"
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

variable "subscription_id" {
  type        = string
  description = "subscription_id"
}

variable "ssh_public_key_data" {
  type        = string
  description = "ssh_public_key_data"
  default     = "var.ssh_public_key_data"
}

variable "mongo_node_count" {
  type        = string
  description = "mongo_node_count"
  default     = "3"
}

variable "mongo_availability_zones" {
  type = list(number)
  description = "Availability zones"
  default     = ["1", "2", "3"]
}

variable "mongo_vm_size" {
  type        = string
  description = "instance type"
  default     = "Standard_L8s_v2"
}

variable "installers_storage_account" {
  type        = string
  description = "installers_storage_account"
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

variable "splunk_index" {
  type        = string
  description = "splunk_index"
  default     = ""
}

variable "networking_resource_group_name" {
  type    = string
  description = "name of private vnet RG"
}

variable "subnet_name" {
  type    = string
  description = "name of private subnet"
}

variable "networking_hubinternet_route_table_name" {
  type        = string
  description = "Networking hub to internet route table name"
}

variable "mongo_subnet_nsg" {
  type        = string
  description = "Name of NetworkSecurity Group"
}


variable "networking_learnedroutes_vnet_name" {
  type    = string
  description = "name of private Vnet"
}

variable "mongo_subnet_cidr" {
  type    = string
  description = "subnet cidr prefix"
}

variable "mongo_storage_account_name" {
  type    = string
  description = "mongo_storage_account_name"
}

variable "mongo_resource_group_name" {
  type    = string
  description = "mongo_resource_group_name"
}

variable "mongo_pdns_resource_group_name" {
  type    = string
  description = "mongo_pdns_resource_group_name"
}

#variable "mongo_subnet_id" {
#  type    = string
#  description = "mongo_subnet_id"
#  default     = ""
#}

variable "mongo_storage_account_name_path"{
  type    = string
  description = "mongo_storage_account_name_path"
  default     = ""

}

variable "tenant_id" {
  type        = string
  description = "tenant_id"
  default     = "f55b1f7d-7a7f-49e4-9b90-55218aad89f8"
}

variable "mongo_min_node_count" {
  type        = number
  default     = "3"
}

variable "mongo_max_node_count" {
  type        = number
  default     = "3"
}

variable "datadisk_size" {
  type = number
  default = 500
}

variable "notify_email" {
  default = "32fbe1bd.tesco.onmicrosoft.com@emea.teams.ms"
  description = "notify_teams channel"
}

variable "mongo_zone_name" {
  type    = string
  description = "zone name"
}

variable "resource_name" {
  type    = string
  description = "Name of the Resources"
  default     = ""
}
