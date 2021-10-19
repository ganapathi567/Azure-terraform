locals {
  zookeeper_servers = [for i in range(var.kafka_broker_count) :
    join(":", [join(".", [join("-", ["kafka", i + 1]), var.sts_pdns_zone_name]), "2181"])]
  
  servers = [for i in range(var.kafka_broker_count) :
    join(":", [join(".", [join("-", ["kafka", i + 1]), var.sts_pdns_zone_name]), "2888:3888"])]
}

data "template_file" "ulimit_content" {
  template = "${file("./templates/limits.conf")}"
}

data "template_file" "kafka_broker_properties" {
  count    = var.kafka_broker_count
  template = file("./templates/server.properties")
  vars     = {
    broker_id       = "${count.index}"
    domain_host     = join(".", [join("-", ["kafka", count.index + 1]), var.sts_pdns_zone_name])
    partitions      = var.kafka_partitions
    zookeeper_nodes = join(",", local.zookeeper_servers)
    admin_username  = local.admin_username
  }
}

data "template_file" "zookeeper_installation" {
  count    = var.kafka_broker_count
  template = file("./templates/zk_install.sh")
  vars     = {
    id = count.index + 1
    java_env_content      = file("./templates/java.env")
    config_file_content  = templatefile("./templates/zoo.cfg", {
      servers = local.servers
    })
    service_file_content = file("./templates/zookeeper.service")

    data_disk_mount_script_content        = module.kafka_disk_attachment.mount_script_content 
    ulimit_content		          = data.template_file.ulimit_content.rendered
    appdynamics_installation_file_content = module.appdynamics.installation_script_content
  }
}

data "template_file" "kafka_broker_installation" {
  count    = var.kafka_broker_count
  template = file("./templates/install.sh")
  vars     = {
    id = count.index + 1
    java_setup_content      = file("./templates/java-setup.sh")
    properties_file_content = element(data.template_file.kafka_broker_properties.*.rendered, count.index)
    jaas_file_content       = file("./templates/kafka_server_jaas.conf")
    kafka_opts_content      = file("./templates/kafka_opts")
    zookeeper_jaas_content  = file("./templates/zookeeper_jaas.conf")
    admin_username = local.admin_username

    config_file_content  = templatefile("./templates/zoo.cfg", {
      servers = local.servers
    })
    service_file_content_zk = file("./templates/zookeeper.service")
    service_file_content    = file("./templates/kafka.service")
    sleep                   = count.index * 30

    data_disk_mount_script_content        = module.kafka_disk_attachment.mount_script_content
    ulimit_content                        = data.template_file.ulimit_content.rendered
    appdynamics_installation_file_content = module.appdynamics.installation_script_content
  }
}

#data "azurerm_key_vault_secret" "kafka_user" {
#  key_vault_id = data.azurerm_key_vault.global.id
#  name         = "sts-kafka-users"
#}
#
#data "azurerm_key_vault" "global" {
#  name                = "eun-ppe-025-sts-global"
#  resource_group_name = "eun-ppe-025-sts-global"
#}

resource "random_password" "kafka_admin_password" {
  length = 16
  special = false
}

data "azurerm_role_definition" "blob_reader" {
  name = "Storage Blob Data Reader"
}

data "azurerm_role_definition" "blob_contributor" {
  name = "Storage Blob Data Contributor"
}
