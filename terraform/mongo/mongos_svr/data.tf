data "template_file" "mongo_admin_init" {
  template = "${file("./templates/admin-user-init.js")}"
  vars     = {
    user     = local.admin_username
    password = random_password.mongo_admin_password.result
  }
}

data "template_file" "mongo_mount_disk" {
  template = "${file("./templates/mount.sh")}"
}

data "template_file" "ulimit_content" {
  template = "${file("./templates/limits.conf")}"
}

data "template_file" "mongo_replica_set_init" {
  template = "${file("./templates/${var.tesco_environment}-replica-set-init.js")}"
#  vars     = {
#    replica_set_name = local.replica_set_name
#    members          = jsonencode(concat(
#      [for i in range(var.mongo_node_count): {
#        "_id"    = "${i}"
#        host     = "${element(module.mongos_svr_nic.ip_addresses, i)}"
#        priority = "${var.mongo_node_count - i}"
#      }]
#    ))
#  }
}

data "template_file" "mongo_conf" {
  template = "${file("./templates/mongos.conf")}"
  vars     = {
    key_file         = local.key_file_path
    replica_set_name = local.replica_set_name
  }
}

data "template_file" "mongo_installation" {
  template = "${file("./templates/install.sh")}"
  vars     = {
    repo_file_content = "${file("./templates/mongodb-org-4.2.repo")}"
    key_file          = local.key_file_path
    key_file_content  = random_password.mongo_key_file_content.result
    conf_file_content = data.template_file.mongo_conf.rendered

    admin_username = var.admin_username
    replica_set_init_file_content = data.template_file.mongo_replica_set_init.rendered
    admin_init_file_content       = data.template_file.mongo_admin_init.rendered
    mount_disk_file_content       = data.template_file.mongo_mount_disk.rendered
    ulimit_content                        = data.template_file.ulimit_content.rendered

    appdynamics_installation_file_content = module.appdynamics.installation_script_content
    splunk_installation_file_content      = module.splunk.installation_script_content
    backup_scheduler_file_content         = module.mongos_svr_backup.scheduler_script_content
  }
}

resource "random_password" "mongo_key_file_content" {
  length = 128
  special = false
}

resource "random_password" "mongo_admin_password" {
  length = 16
  special = false
}

data "azurerm_role_definition" "blob_reader" {
  name = "Storage Blob Data Reader"
}

data "azurerm_role_definition" "blob_contributor" {
  name = "Storage Blob Data Contributor"
}
