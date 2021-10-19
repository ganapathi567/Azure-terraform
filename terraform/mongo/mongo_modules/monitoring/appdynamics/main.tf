locals {
  controller_host  = var.appdynamics_controller_host
  account          = var.appdynamics_account
  access_key       = var.appdynamics_access_key
  application_name = "sts-dev-${var.tesco_environment}"
  tier_name        = "${var.tesco_team_name}-${var.service_name}"
}

data "template_file" "appdynamics_machineagent_installation_file" {
  template = file("${path.module}/templates/install-appdynamics-machineagent.sh")
  vars     = {
    subscription_id                           = var.subscription_id
    storage_account                           = var.installers_storage_account
    controller_info_file_content              = data.template_file.controller_info_file.rendered
    process_monitor_config_file_content       = data.template_file.process_monitor_config_file.rendered
    machineagent_systemd_service_file_content = file("${path.module}/templates/appdynamics-machine-agent.service")
  }
}

data "template_file" "controller_info_file" {
  template = file("${path.module}/templates/controller-info.xml")
  vars     = {
    controller_host  = local.controller_host
    account          = local.account
    access_key       = local.access_key
    application_name = local.application_name
    tier_name        = local.tier_name
  }
}

data "template_file" "process_monitor_config_file" {
  template = file("${path.module}/templates/conf.yml")
  vars     = {
    tier_name     = local.tier_name
    service_name  = var.service_name
    monitor_type  = var.service_process_monitor_type
    monitor_value = var.service_process_monitor_value
  }
}
