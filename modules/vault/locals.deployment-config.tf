locals {
  deployment_config_presets = {
    all = {
      vault = {
        count = 1
      }
    }
    ethereum_storage = {
      vault = {
        count = 0
      }
    }
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
