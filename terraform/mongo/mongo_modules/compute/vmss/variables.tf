variable "resource_name" {}
variable "mongo_resource_group_name" {}
variable "location" {}
variable "mongo_subnet_id" {}
variable "vmss_size" {}
variable "vmss_count" {}
variable "admin_username" {}
variable "script_file_content" {}
variable "ssh_public_key_data" {}
variable "storage_account_name" {}
variable "datadisk_size" {}
variable "module_depends_on" {}
#variable "user_assigned_identity_ids" {
#  type = list(string)
#}
variable "tags" {
  type = map(string)
}
