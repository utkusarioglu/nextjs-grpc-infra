locals {
  private_deployment_config_templates = {
    all = {
      postgres_tablespaces_sc = {
        count = 1
      }
      vault_scs = {
        for_each = toset(["vault-data-sc", "vault-audit-sc"])
      }
      source_code_pvs = {
        for_each = toset(["api", "ms"])
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
