locals {
  application_name = "${var.tesco_team_name}-${var.tesco_environment}-${var.service_name}"
  source_type      = "${var.tesco_team_name}-${var.service_name}"
  storage_container_name = var.storage_backup_container
}

data "template_file" "backup_scheduler_file" {
  template = file("${path.module}/templates/scheduler.sh")
  vars     = {
    service_name  = var.service_name
    backup_script = templatefile("${path.module}/templates/backup.sh", {
      subscription_id       = var.subscription_id
      service_name          = var.service_name
      source_type           = local.source_type
      application_name      = local.application_name
      storage_account       = var.storage_account
      storage_container_name = local.storage_container_name
      log_path              = var.log_path
      service_backup_script = var.service_backup_script
    })
  }
}