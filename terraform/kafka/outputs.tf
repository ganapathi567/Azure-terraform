output "kafka_admin_password" {
  value     = random_password.kafka_admin_password.result
  sensitive = true
}
