variable "resource_name" {}
variable "vmss_id" {}
variable "location" {}
variable "notify_email" {}
variable "vmss_sku_min_capacity" {}
variable "vmss_sku_max_capacity" {}
variable "kafka_resource_group_name" {}
variable "module_depends_on" {
  type    = any
  default = [""]
}
variable "tags" {
  type = map(string)
}
