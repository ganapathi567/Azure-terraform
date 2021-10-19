variable "resource_group_name" {}
variable "location" {}

variable "vm_count" {}
variable "vm_name" {}

variable "subnet_id" {}

variable "private_ip_address_allocation" {
  default = "Dynamic"
}

variable "private_ip_addresses" {
  type = list(string)
  default = []
}

variable "tags" {
  type = map(string)
}

variable "module_depends_on" {
  type    = any
  default = [""]
}
