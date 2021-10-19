locals {
  application_name = "${var.tesco_team_number}-${var.tesco_team_name}-${var.tesco_environment}-mongo"
  source_type      = "${var.tesco_team_name}-${var.service_name}"
}

data "template_file" "splunk_forwarder_installation_file" {
  template = file("${path.module}/templates/install.sh")
  vars     = {
    subscription_id          = var.subscription_id
    storage_account          = var.installers_storage_account
    inputs_conf_file_content = templatefile("${path.module}/templates/inputs.conf", {
      index            = var.index
      source_type      = local.source_type
      application_name = local.application_name
      env              = var.tesco_environment
      monitors         = var.monitors
    })
  }
}
