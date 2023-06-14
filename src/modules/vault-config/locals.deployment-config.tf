locals {
  deployment_config_templates = {
    all = {
      vault_config = {
        count = 1
      }
      namespaces = {
        for_each = ["api", "ms", "observability", "cert-manager"]
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
