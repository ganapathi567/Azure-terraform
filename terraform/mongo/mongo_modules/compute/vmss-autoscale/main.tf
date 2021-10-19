resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = var.resource_name
  resource_group_name = var.mongo_resource_group_name
  location            = var.location
  target_resource_id  = var.vmss_id

  profile {
    name = var.resource_name

    capacity {
      default = var.vmss_sku_min_capacity
      minimum = var.vmss_sku_min_capacity
      maximum = var.vmss_sku_max_capacity
    }
  }
#    rule {
#      metric_trigger {
#        metric_name        = "Percentage CPU"
#        metric_resource_id = var.vmss_id
#        time_grain         = "PT1M"
#        statistic          = "Average"
#        time_window        = "PT5M"
#        time_aggregation   = "Average"
#        operator           = "GreaterThan"
#        threshold          = 75
#      }

#      scale_action {
#        direction = "Increase"
#       type      = "ChangeCount"
#        value     = "0"
#        cooldown  = "PT1M"
#      }
#    }

#    rule {
#      metric_trigger {
#        metric_name        = "Percentage CPU"
#        metric_resource_id = var.vmss_id
#        time_grain         = "PT1M"
#        statistic          = "Average"
#        time_window        = "PT5M"
#        time_aggregation   = "Average"
#        operator           = "LessThan"
#        threshold          = 25
#      }

#      scale_action {
#        direction = "Decrease"
#        type      = "ChangeCount"
#        value     = "0"
#        cooldown  = "PT1M"
#      }
#    }
#  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = [var.notify_email]
    }
  }

  depends_on = [var.module_depends_on]

  tags = var.tags
}
