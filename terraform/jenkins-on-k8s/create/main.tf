module "jenkins" {
  source = "git@github.dev.global.tesco.org:TescoSharedPlatform/terraform-kubernetes-jenkins.git?ref=0.3.0"

  aks_principal_id = var.aks_principal_id

  backup_disk_space_in_gb = 20

  keyvault_id = var.keyvault_id
  keyvault_name = var.keyvault_name

  location = var.location
  subscription_name = var.subscription_name

  tesco_environment = var.tesco_environment
  tesco_team_name = var.tesco_team_name

  jenkins_name = "sts"
  jenkins_base_plugins = var.jenkins_base_plugins
  helm_values_path = "custom_helm_values.yaml"

  github_client_id = var.github_client_id
  github_client_secret = var.github_client_secret
  github_organization = var.github_organization
  github_team_slug = var.github_team_slug
}
