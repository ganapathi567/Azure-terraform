variable "resource_group_name" {}
variable "region" {}

variable "resource_names" {
  type = list(string)
  description = "The resource name. It has 24 character length constraint."
}

variable "tags" {
  type = map(string)
}
