locals {
  deployment_config_presets = {
    all = {
      cert_manager = {
        count = 1
      }
      namespaces = {
        for_each = ["cert-manager"]
      }
    }
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
