tesco_team_name = "sts"
tesco_environment = "ppe"
subscription_name = "025-PROD-APP-1"
subscription_id = "9f813689-c99d-4bb7-8f2f-cf48b6b7c046"
location = "northeurope"
tenant_id = "f55b1f7d-7a7f-49e4-9b90-55218aad89f8"

tesco_tags = {
  sub_type = "ppe_test"
  team_number = "025"
}


admin_username = "sts-admin"
ssh_public_key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR12Zrs0ocpNCyqEi/0G4Se//qQK8ObIYqsgmjZpY4CuCRXN2ser1rjQW88sQp1EQR9peq8EvIaySHaPXkm6LXToUzS1TCU1fyerV4xNfoLtuY4a1r6fqgoJXDewIienAqHJ550exCrqEgRYXo9luLyUKH7ro2M+ef3BREYN4vXsxU/R6SMeOGyu1f1iZ6uBv9PF1U73HRzzAJmbE3ZLT1fVKq5eCmU2/oiU+bp5rkcdx7HdB4JPfoCcGrh9VcCNZHBwjhjVYC46fy77EmF2fAtqrwTkkwm6PHQbfuAVhzFv91jzTiWgnac8c7OyQAwO+fdjFCb96EiPKVY/6b/a+r sts-admin@eun-ppe-025-sts-jumpserver"

#ssh_public_key_data = "/home/sts-admin/.ssh/id_rsa.pub"

networking_resource_group_name = "eun-prod-025-frs-net"
networking_hubinternet_route_table_name = "eun-prod-025-frs-hubinternet"
networking_learnedroutes_vnet_name = "eun-prod-025-frs-learnedroutes"
#networking_azdefaultroutes_vnet_name = "eun-prod-025-frs-azdefaultroutes"
subnet_name = "eun-ppe-025-sts-mongo"

# Management
installers_storage_account = "eun025stsglobal"
installers_storage_account_container_path = "/subscriptions/9f813689-c99d-4bb7-8f2f-cf48b6b7c046/resourceGroups/eun-025-sts-global/providers/Microsoft.Storage/storageAccounts/eun025stsglobal/blobServices/default/containers/installers"

# Mongo
mongo_resource_group_name = "eun-ppe-025-sts-mongo"
mongo_pdns_resource_group_name = "eun-prod-025-sts-pdns"
mongo_storage_account_name = "eunppe025stsmongo"
#mongo_storage_account_name_path = "/subscriptions/9f813689-c99d-4bb7-8f2f-cf48b6b7c046/resourceGroups/eun-ppe-025-sts-mongo/providers/Microsoft.Storage/storageAccounts/eunppe025stsmongo"
mongo_subnet_cidr = "10.122.6.0/27"
mongo_subnet_nsg = "eun-ppe-025-sts-mongo-nsg"
mongo_vm_size = "Standard_L8s_v2"
mongo_node_count = 3
mongo_availability_zones = [1, 2, 3]
mongo_zone_name = "ppe.sts.eun.azure.tesco.org"
mongo_min_node_count = 3
mongo_max_node_count = 3
resource_name = "eun-ppe-025-sts-mongo-shard-uk"
jumpserver_name_rg = "eun-ppe-025-sts-jumpbox-rg"
