output "sftp_admin_password" {
  value     = random_password.sftp_admin_password.result
  sensitive = true
}
