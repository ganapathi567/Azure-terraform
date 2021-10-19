variable "app_service_principal_name" {
  type        = string
  description = "The name of the app service principal used by STS applications."
}

variable "owner_object_ids" {
  type        = list(string)
  description = "The object ids of a service principal or user that should be the owner of the created AD resources"
}