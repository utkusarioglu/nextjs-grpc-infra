locals {
  private_deployment_config_templates = {
    all = {
      postgres_tablespaces_pvc = {
        count = 1
      }
      postgres_storage = {
        count = 1
      }
      postgres_dumps_configmap = {
        count = 1
      }
    }
    none = {
      postgres_tablespaces_pvc = {
        count = 0
      }
      postgres_storage = {
        count = 0
      }
      postgres_dumps_configmap = {
        count = 0
      }
    }
  }

  private_deployment_config_presets = {
    all              = local.private_deployment_config_templates.all
    no_observability = local.private_deployment_config_templates.all
    data_workshop    = local.private_deployment_config_templates.all
    grafana          = local.private_deployment_config_templates.none
  }

  deployment_configs = local.private_deployment_config_presets[var.deployment_mode]
}
