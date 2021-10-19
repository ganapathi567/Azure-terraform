output "installation_script_content" {
  value     = data.template_file.appdynamics_machineagent_installation_file.rendered
  sensitive = false
}
