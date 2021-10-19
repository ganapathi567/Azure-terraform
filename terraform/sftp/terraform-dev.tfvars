tesco_team_name = "sts"
tesco_environment = "dev"
subscription_name = "025-DEV-APP-1"
subscription_id = "9b5ef196-6cf0-4c6c-bea7-68dc747ee888"
location = "northeurope"
tenant_id = "f55b1f7d-7a7f-49e4-9b90-55218aad89f8"

tesco_tags = {
  sub_type = "dev_test"
  team_number = "025"
}

admin_username = "azureuser"
ssh_public_key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMNJS6nf9NKz5IIvVFJfzy6iBGy1y7iXPLV6FX0coCBpZ/iNA/7bTNkLCmOrEcm6t4djSHNsmUOutAjRRkgEQIIGzXIOo73ajIn+pJ9gU6iuirWrMDrgwpVcqAnI4s6tKsMKK359sk1f+pXsVeMXJ8ER8e+6vv0+Ik6FFxb6n61EMN33hSd3s+dcqEIxnH7A5lHoc7q6nF2+ZqNqZ4EXXsMyMMkGCXKNcCX2+l7e47b3jWKXHje/lwZXXpMzUx6pVruSHQiXQjCcAXxlqSOrhmuzFYkH66vfzEwupg+kT6bgl/jEpdEuRwiXomMZApt6TNXTgTydTkOjAnepZjyhAN sts-admin@STS-jump-server"


networking_resource_group_name = "eun-dev-025-frs-net"
networking_hubinternet_route_table_name = "eun-dev-025-frs-hubinternet"
networking_learnedroutes_vnet_name = "eun-dev-025-frs-learnedroutes"
#networking_azdefaultroutes_vnet_name = "eun-dev-025-frs-defaultroutes"
dev_sftp_subnet = "eun-dev-025-sts-sftp"

#STS PDNS Zone
#sts_dev_pdns_resource_group_name = "eun-dev-025-sts-pdns"
#sts_pdns_zone_name = "zone.sts.dev.eun.azure.tesco.org"

# Management
#installers_storage_account = "eundev025stsglobal"
#installers_storage_account_container_path = "/subscriptions/9b5ef196-6cf0-4c6c-bea7-68dc747ee888/resourceGroups/eun-dev-025-sts-global/providers/Microsoft.Storage/storageAccounts/eundev025stsglobal/blobServices/default/containers/installers"


#Sftp 
sftp_storage_account_name = "eundev025stsapp"
store_finalization_storage_container_name = "sts-dev-store-finalization-events"
bank_statement_storage_container_name = "sts-dev-bank-statement-events"
sts_app_resource_group_name = "eun-dev-025-sts-app"
sftp_subnet_cidr = "10.119.217.160/28"
sftp_subnet_id = "eun-dev-025-sts-sftp"
sftp_vm_size = "Standard_D2s_v3"
sftp_vm_count = 1
#sftp_availability_zones = [1]
