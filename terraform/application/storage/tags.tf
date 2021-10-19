locals {
  environment_from_subscription = lower(element(local.shortcodes, 1))
  sub_type                      = local.environment_from_subscription == "prod" ? "prod" : "dev_test"

  tesco_tags = {
    "team_number" = local.team_number,
    "sub_type"    = local.sub_type,
  }

  all_tags = merge(var.tags, local.tesco_tags)
}