variable "vm_ids" {
  type = list(string)
}

variable "script_file_content" {
  type = map(string)
}

variable "module_depends_on" {
  type    = any
  default = [""]
}

variable "tags" {
  type = map(string)
}
