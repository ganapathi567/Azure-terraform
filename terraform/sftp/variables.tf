variable "subscription_name" {
  type        = string
  description = "Name of the subscription (e.g. 025-DEV-APP-1)"
  default     = "025-DEV-APP-1"
}

variable "tesco_team_name" {
  type        = string
  description = "Three letter team name (e.g. STS)"
  default     = "sts"
}

variable "tesco_environment" {
  type        = string
  description = "Name of the environment (e.g. dev)"
  default     = "dev"
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
  default     = "azureuser"
}

variable "ssh_public_key_data" {
  type        = string
  description = "ssh_public_key_data"
  default     = "var.ssh_public_key_data"
}

variable "networking_resource_group_name" {
  type        = string
  description = "Networking resource group name, e.g. 'eun-dev-025-frs-net'"
  default     = "eun-dev-025-frs-net"
}

variable "networking_learnedroutes_vnet_name" {
  type        = string
  description = "Networking learnedroutes VNET name, e.g. 'eun-dev-025-frs-learnedroutes'"
 default     = "eun-dev-025-frs-learnedroutes"
}

variable "networking_hubinternet_route_table_name" {
  type        = string
  description = "Networking hub to internet route table name, e.q. 'eun-dev-025-frs-hubinternet'. If set will be assosiated with aks (-application) subnet"
  default     = ""
}

variable "sftp_subnet" {
  type    = string
  description = "name of private subnet"
}

variable "sftp_subnet_cidr" {
  type        = string
  description = "subnet_cidr"
}

variable "sftp_vm_size" {
  type        = string
  description = "instance type"
  default     = "Standard_DS2_v2"
}

variable "sftp_vm_count" {
  type        = number
  description = "dev sftp node"
  default     = "1"
}

variable "sftp_availability_zones" {
  type        = list(number)
  description = "Availability zones"
  default     = ["1"]
}

variable "installers_storage_account_container_path" {
  type    = string
  description = "installers_storage_account_container_path"
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

variable "sts_resource_group_name" {
  type    = string
  description = "sts_app_resource_group_name"
}

variable "stsapp_resource_group_name" {
  type    = string
  description = "sts_app_resource_group_name"
}

variable "sftp_storage_account_name" {
  type = string
  description = "sftp_storage_account_name"
  default     = "eundev025stsapp"
}

variable "store_finalization_storage_container_name" {
  type = string
  description = "sts-dev-store-finalization-events"
  default     = "sts-dev-store-finalization-events"
}
variable "bank_statement_storage_container_name" {
  type = string
  description = "sts-dev-bank-statement-events"
  default     = "sts-dev-bank-statement-events"
}
