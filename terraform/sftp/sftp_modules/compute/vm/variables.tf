variable "resource_group_name" {}
variable "location" {}

variable "vm_count" {}
variable "vm_name" {}
variable "vm_size" {}
#variable "script_file_content" {}

variable "nic_ids" {
  type = list(string)
}

variable "availability_zones" {
  type    = list(number)
  default = [3]
}

#variable "user_assigned_identity_ids" {
#  type = list(string)
#}

variable "storage_account_name" {}

variable "admin_username" {}

variable "ssh_public_key_data" {}

variable "module_depends_on" {
  type    = any
  default = [""]
}

variable "tags" {
  type = map(string)
}

variable "storage_managed_disk_type" {
  type    = string
  default = "Premium_LRS"
}

variable "isZonesRequired" {
  type    = bool
  default = true
}

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

variable "os_disk_size_gb" {
  type    = number
  default = 30
}
