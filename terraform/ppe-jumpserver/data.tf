data "template_file" "azure_cli_file" {
  template = "${file("./templates/azure_cli.sh")}"
   }

data "template_file" "mongo_mount_disk" {
  template = "${file("./templates/mount.sh")}"
  vars  = {
    admin_username = var.admin_username   
   }
}

data "template_file" "java_setup_file" {
  template = "${file("./templates/java-setup.sh")}"
  vars  = {
    admin_username = var.admin_username
   }
}

data "template_file" "sftp_setup" {
  template = "${file("./templates/install.sh")}"
  vars     = {
    azure_cli_file_content	  = data.template_file.azure_cli_file.rendered
    mount_disk_file_content       = data.template_file.mongo_mount_disk.rendered
    java_setup_content		  = data.template_file.java_setup_file.rendered
    admin_username		  = var.admin_username

  }
}

resource "random_password" "admin_password" {
  length = 16
  special = false
}

data "azurerm_role_definition" "blob_reader" {
  name = "Storage Blob Data Reader"
}

data "azurerm_role_definition" "blob_contributor" {
  name = "Storage Blob Data Contributor"
}
