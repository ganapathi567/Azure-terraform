variable "tesco_environment" {
  type        = string
  description = "Name of the environment (e.g. dev)"
}

variable "tesco_team_name" {
  type        = string
  description = "Three letter team name (e.g. STS)"
}

variable "subscription_id" {}

variable "installers_storage_account" {
  type        = string
  description = "Installers storage account name"
}

variable "service_name" {}

variable "service_process_monitor_type" {
  default = "pidFile"
}

variable "service_process_monitor_value" {}

variable "appdynamics_controller_host" {}
variable "appdynamics_account" {}
variable "appdynamics_access_key" {}
