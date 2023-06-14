locals {
  deployment_config_templates = {
    all = {
      postgres_tablespaces_sc = {
        count = 1
      }
      vault_sc = {
        for_each = toset(["vault-data-sc", "vault-audit-sc"])
      }
    }
  }

  deployment_config_presets = {
    all = local.deployment_config_templates.all
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
