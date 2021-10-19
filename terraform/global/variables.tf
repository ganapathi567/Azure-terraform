variable "subscription_name" {
  type        = string
  description = "Name of the subscription (e.g. 025-DEV-APP-1)"
}

variable "tesco_team_name" {
  type        = string
  description = "Three letter team name (e.g. STS)"
}

variable "tesco_environment" {
  type        = string
  description = "Name of the environment (e.g. dev)"
}

variable "location" {
  type        = string
  description = "Location"
}