resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  count              = length(var.vm_ids)
  managed_disk_id    = element(var.disk_ids, count.index)
  virtual_machine_id = element(var.vm_ids, count.index)
  lun                = "1"
  caching            = "ReadWrite"

  depends_on = [var.module_depends_on]
}

data "template_file" "mount_data_disk_script" {
  template = file("${path.module}/templates/mount.sh")
}
