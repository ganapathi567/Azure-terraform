output "scheduler_script_content" {
  value     = data.template_file.backup_scheduler_file.rendered
  sensitive = false
}
