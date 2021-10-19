resource "azurerm_virtual_machine_extension" "ext" {
  count = length(var.vm_ids)

  name                 = "Configuration"
  virtual_machine_id   = element(var.vm_ids, count.index)
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  protected_settings = <<PROT
  {
    "script": "${base64encode(var.script_file_content[element(var.vm_ids, count.index)])}"
  }
PROT

  depends_on = [var.module_depends_on]

  tags = var.tags
}

