locals {
  private_deployment_config_templates = {
    all = {
      vault = {
        count = 1
      }
    }
  }
  private_deployment_config_presets = {
    all              = local.private_deployment_config_templates.all
    no_observability = local.private_deployment_config_templates.all
    data_workshop    = local.private_deployment_config_templates.all
    grafana          = local.private_deployment_config_templates.all
  }

  deployment_configs = local.private_deployment_config_presets[var.deployment_mode]
}
