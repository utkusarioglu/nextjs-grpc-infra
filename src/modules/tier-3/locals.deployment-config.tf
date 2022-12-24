locals {
  deployment_config_presets = {
    all = {
      jaeger = {
        count = 1
      }
    }

    up_till_cert_manager = {
      jaeger = {
        count = 0
      }
    }

    ethereum_storage = {
      jaeger = {
        count = 1
      }
    }
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
