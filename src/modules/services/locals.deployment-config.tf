locals {
  deployment_config_templates = {
    all = {
      api = {
        count = 0
      }
      web_server = {
        count = 1
      }
      ms = {
        count = 1
      }
    }
    none = {
      api = {
        count = 0
      }
      web_server = {
        count = 0
      }
      ms = {
        count = 0
      }
    }
  }

  deployment_config_presets = {
    all              = local.deployment_config_templates.all
    no_observability = local.deployment_config_templates.all
    data_workshop    = local.deployment_config_templates.none
    grafana          = local.deployment_config_templates.none
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
