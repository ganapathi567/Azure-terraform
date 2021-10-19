variable "resource_group" {}
variable "region" {}
variable "disk_size_gb" {}
variable "vm_name" {}
variable "vm_count" {}

variable "availability_zones" {
  type    = list(number)
  default = [1]
}

variable "module_depends_on" {
  type    = any
  default = [""]
}

variable "tags" {
  type = map(string)
}

variable "storage_account_type" {
  type = string
  default = "Standard_LRS"
}
