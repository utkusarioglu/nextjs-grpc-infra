locals {
  deployment_config_templates = {
    all = {
      certificates = {
        count = 1
      }
      cert_namespaces = {
        for_each = toset(["api", "ms", "observability"])
      }
      networking = {
        count = 0
      }
      rbac = {
        count = 1
      }
      secrets = {
        count = 0
      }
    }
  }

  deployment_config_presets = {
    all              = local.deployment_config_templates.all
    no_observability = local.deployment_config_templates.all
    data_workshop    = local.deployment_config_templates.all
    grafana          = local.deployment_config_templates.all
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
