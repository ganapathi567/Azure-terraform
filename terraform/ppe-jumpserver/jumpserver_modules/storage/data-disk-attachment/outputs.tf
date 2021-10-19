output "ids" {
  value = azurerm_virtual_machine_data_disk_attachment.data_disk_attachment.*.id
}

#output "mount_script_content" {
#  value = data.template_file.mount_data_disk_script.rendered
#}
