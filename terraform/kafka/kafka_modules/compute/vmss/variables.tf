variable resource_name {}
variable "location" {}
variable "kafka_resource_group_name" {}
variable "kafka_subnet_id" {}
variable "vmss_size" {}
variable "vmss_count" {}
variable "admin_username" {}
variable "ssh_public_key_data" {}
#variable "script_file_content" {
  #type    = string
#}
variable "storage_account_name" {}
variable "datadisk_size" {}
variable "module_depends_on" {}
#variable "user_assigned_identity_ids" {
#  type = list(string)
#}

variable "publisher" {
  type    = string
  default = "OpenLogic"
}

variable "offer" {
  type    = string
  default = "CentOS"
}

variable "sku" {
  type    = string
  default = "7.5"
}

variable "tags" {
  type = map(string)
}
