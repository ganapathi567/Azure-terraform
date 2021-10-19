variable "resource_name" {}
variable "vmss_id" {}
variable "script_file_content" {
  #type = list(string) 
}
variable "module_depends_on" {
  type    = any
  default = [""]
}
