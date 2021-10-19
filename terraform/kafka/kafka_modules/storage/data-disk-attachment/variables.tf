variable "vm_ids" {
  type = list(string)
}

variable "disk_ids" {
  type = list(string)
}

variable "module_depends_on" {
  type    = any
  default = [""]
}
