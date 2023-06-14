locals {
  deployment_config_templates = {
    all = {
      postgres_storage = {
        count = 1
      }
      postgres_storage_inflation_roles = {
        for_each = local.postgres_storage_vault_roles.inflation
      }
      postgres_storage_ai_education_public_roles = {
        for_each = local.postgres_storage_vault_roles.ai_education_public
      }
      postgres_storage_ai_education_restricted_roles = {
        for_each = local.postgres_storage_vault_roles.ai_education_restricted
      }
    }
    none = {
      postgres_storage = {
        count = 0
      }
      postgres_storage_inflation_roles = {
        for_each = toset([])
      }
      postgres_storage_ai_education_public_roles = {
        for_each = toset([])
      }
      postgres_storage_ai_education_restricted_roles = {
        for_each = toset([])
      }
    }
  }

  deployment_config_presets = {
    all              = local.deployment_config_templates.all
    no_observability = local.deployment_config_templates.all
    data_workshop    = local.deployment_config_templates.all
    grafana          = local.deployment_config_templates.none
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
