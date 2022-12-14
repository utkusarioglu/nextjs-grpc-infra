locals {
  deployment_config_presets = {
    all = {
      vault = {
        count = 1
      }
      namespaces = {
        for_each = ["api", "ms", "observability", "cert-manager"]
      }
    }

    ethereum_storage = {
      vault = {
        count = 0
      }

      namespaces = {
        for_each = ["api", "ms", "observability", "cert-manager"]
      }
    }

    up_till_cert_manager = {
      vault = {
        count = 1
      }
      namespaces = {
        for_each = ["api", "ms", "observability", "cert-manager"]
      }
    }
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
