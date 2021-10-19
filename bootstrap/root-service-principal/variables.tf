variable "tf_storage_account_name" {
  type        = string
  description = "The storage account name, from which the terraform state is taken"
}

variable "tf_storage_account_resource_group" {
  type        = string
  description = "The resource group name, which contains the backend storage account"
}

variable "root_service_principal_name" {
  type        = string
  description = "The name of the (root) service principal used by Terraform scripts."
}