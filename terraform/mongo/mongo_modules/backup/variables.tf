variable "tesco_environment" {
  type        = string
  description = "Name of the environment (e.g. dev)"
}

variable "tesco_team_name" {
  type        = string
  description = "Three letter team name (e.g. STS)"
}

variable "subscription_id" {}
variable "storage_account" {}
variable "service_name" {}
variable "log_path" {}
variable "service_backup_script" {}

variable "storage_backup_container" {
  type    	  = string
  description = "storage container for backup"
  default     = "dev-025-mongo-uk-backup"
}