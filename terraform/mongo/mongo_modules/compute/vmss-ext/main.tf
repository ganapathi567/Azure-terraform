resource "azurerm_virtual_machine_scale_set_extension" "ext" {
  name                         = var.resource_name
  virtual_machine_scale_set_id = var.vmss_id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.0"

  protected_settings = <<PROT
  {
    "script": "${base64encode(var.script_file_content)}"
  }
PROT

  depends_on = [var.module_depends_on]
}
