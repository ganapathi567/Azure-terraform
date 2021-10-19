variable "role_assignment_scopes" {
  type        = list(string)
  description = "The scope at which the Role Assignment applies too, such as /subscriptions/id"
}

variable "role_definition_id" {
  description = "The id of the Role - Conflicts with name"
}

variable "assignee_principal_id" {
  description = "The ID of the Managed Identity or Service Principal"
}

variable "module_depends_on" {
  type    = any
  default = []
}
