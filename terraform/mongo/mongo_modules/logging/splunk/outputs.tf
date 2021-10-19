output "installation_script_content" {
  value     = data.template_file.splunk_forwarder_installation_file.rendered
  sensitive = false
}
