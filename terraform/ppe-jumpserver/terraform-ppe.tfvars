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


admin_username = "stsAdmin"
ssh_public_key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMNJS6nf9NKz5IIvVFJfzy6iBGy1y7iXPLV6FX0coCBpZ/iNA/7bTNkLCmOrEcm6t4djSHNsmUOutAjRRkgEQIIGzXIOo73ajIn+pJ9gU6iuirWrMDrgwpVcqAnI4s6tKsMKK359sk1f+pXsVeMXJ8ER8e+6vv0+Ik6FFxb6n61EMN33hSd3s+dcqEIxnH7A5lHoc7q6nF2+ZqNqZ4EXXsMyMMkGCXKNcCX2+l7e47b3jWKXHje/lwZXXpMzUx6pVruSHQiXQjCcAXxlqSOrhmuzFYkH66vfzEwupg+kT6bgl/jEpdEuRwiXomMZApt6TNXTgTydTkOjAnepZjyhAN sts-admin@STS-jump-server"

#ssh_public_key_data = "/home/azureuser/.ssh/id_rsa.pub"

networking_resource_group_name = "eun-prod-025-frs-net"
networking_hubinternet_route_table_name = "eun-ppe-025-sts-hubinternet"
networking_learnedroutes_vnet_name = "eun-prod-025-frs-learnedroutes"
#networking_azdefaultroutes_vnet_name = "eun-prod-025-frs-azdefaultroutes"
subnet_name = "eun-ppe-025-sts-jumpbox"


# Mongo
resource_group_name = "eun-ppe-025-sts-jumpbox"
subnet_cidr = "10.115.76.96/29"
subnet_nsg = "eun-ppe-025-sts-jumpbox"
vm_size = "Standard_D3_v2"
availability_zones = [1]
vm_count = 1
resource_name = "eun-ppe-025-sts-jumpbox"
