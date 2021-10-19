owner_object_ids = [
  "3d56eef0-7486-4e21-b4e1-3e6ac32c3c27",
  "25771ac6-e4bf-42f3-8fc7-44851671bf8a",
  "96bf77e5-7920-4383-8880-a830db3a186f",
  "d2d419f4-9ef3-4ce2-a81b-44d9e755605c"
]
service_principal_name = "eun-ppe-025-sts-externalaksbasic"

tesco_environment = "ppe"
tesco_team_name = "sts"
subscription_name = "025-PROD-APP-1"
location = "northeurope"

aks_name_suffix = "externalaks"
resource_group_name_suffix = "externalaks"
aks_subnet_name_suffix = "externalapplication"
aks_agent_count = 1
## /26 = 64 ips, range: 10.122.5.0 - 10.122.5.63
aks_subnet_cidrs = [
  "10.122.5.0/26"]
aks_pod_cidr = ""
aks_subnet_service_endpoints = [
  "Microsoft.Storage",
  "Microsoft.ContainerRegistry"]
aks_network_plugin = "azure"
api_server_authorized_ip_ranges = []
kubernetes_version = "1.19.11"
enable_nightly_auto_shutdown = false

networking_base_name = "eun-prod-025-frs"
az_prefix = "az"

regular_node_pools = [
  {
    name = "vision"
    os_disk_size_gb = 30
    vm_size = "Standard_DS3_v2"
    max_count = 5
    min_count = 1
    node_count = 1
    max_pods = 10
    availability_zones = [
      1,
      2,
      3]
    enable_auto_scaling = true
    node_taints = []
    mode = "User"
    node_labels = {}
    kubernetes_version = "1.18.19"
  }]