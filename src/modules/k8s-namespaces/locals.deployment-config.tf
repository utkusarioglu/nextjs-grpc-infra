locals {
  deployment_config_templates = {
    all = {
      namespaces = {
        for_each = toset(["api", "vault", "ms", "observability"])
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
