provider "azuread" {
  version = ">=1.0.0"
}

provider "azurerm" {
  version = ">=2.14.0"
  features {}
}


data "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = var.aks_cluster_name
  resource_group_name = var.aks_cluster_resource_group_name
}

provider "kubernetes" {
  version = "=1.13.3"
  host = data.azurerm_kubernetes_cluster.aks-cluster.kube_config.0.host

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks-cluster.kube_admin_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks-cluster.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks-cluster.kube_admin_config.0.cluster_ca_certificate)
}

provider "helm" {
  version = "=1.3.2"
  kubernetes {
    host             = data.azurerm_kubernetes_cluster.aks-cluster.kube_config.0.host

    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks-cluster.kube_admin_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks-cluster.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks-cluster.kube_admin_config.0.cluster_ca_certificate)
  }
}
