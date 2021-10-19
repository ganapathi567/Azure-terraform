output "mongo_admin_password" {
  value     = random_password.mongo_admin_password.result
  sensitive = true
}
