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
  description = "Name of the environment (e.g. dev)"
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
}

variable "ssh_public_key_data" {
  type        = string
  description = "ssh_public_key_data"
  default     = "var.ssh_public_key_data"
}

variable "networking_resource_group_name" {
  type        = string
  description = "Networking resource group name, e.g. 'eun-dev-025-frs-net'"
  default     = ""
}

variable "networking_learnedroutes_vnet_name" {
  type        = string
  description = "Networking learnedroutes VNET name, e.g. 'eun-dev-025-frs-learnedroutes'"
 default     = ""
}

variable "networking_hubinternet_route_table_name" {
  type        = string
  description = "Networking hub to internet route table name, e.q. 'eun-dev-025-frs-hubinternet'. If set will be assosiated with aks (-application) subnet"
  default     = ""
}

variable "subnet_name" {
  type    = string
  description = "name of private subnet"
  default     = ""
}

variable "subnet_cidr" {
  type        = string
  description = "subnet_cidr"
  default     = ""
}

variable "vm_size" {
  type        = string
  description = "instance type"
  default     = ""
}

variable "vm_count" {
  type        = number
  description = "no of jumpserver node"
  default     = "1"
}


variable "tenant_id" {
  type        = string
  description = "tenant_id"
  default     = ""
}

variable "subscription_id" {
  type        = string
  description = "subscription_id"
}


variable "resource_group_name" {
  type    = string
  description = "jumpserver resource_group_name"
  default     = ""
}

variable "subnet_nsg" {
  type    = string
  description = "jumpserver subnet_nsg"
  default     = ""
}

variable "resource_name" {
  type    = string
  description = "jumpserver resource_name"
  default     = ""
}

variable "availability_zones" {
  type = list(number)
  description = "Availability zones"
  default     = [1]
}
