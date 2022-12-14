locals {
  deployment_config_presets = {
    all = {
      ingress = {
        count = 1
      }
    }
    ethereum_storage = {
      ingress = {
        count = 1
      }
    }
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
