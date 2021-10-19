variable "tesco_environment" {
  type        = string
  description = "Name of the environment (e.g. dev)"
}

variable "tesco_team_name" {
  type        = string
  description = "Three letter team name (e.g. CPE)"
}

variable "tesco_team_number" {
  type        = string
  description = "serial number of team"
}

variable "subscription_id" {}

variable "installers_storage_account" {
  type        = string
  description = "Installers storage account name"
}

variable "index" {}
variable "service_name" {}

variable "monitors" {
  type = list(string)
}
