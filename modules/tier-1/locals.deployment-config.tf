locals {
  deployment_config_presets = {
    all = {
      cert_manager = {
        count = 1
      }
      certificates = {
        count = 1
      }
      namespaces = {
        for_each = ["api", "ms", "observability"]
      }
      networking = {
        count = 0
      }
      otel_operator = {
        count = 1
      }
      ethereum_pv = {
        count = 1
      }
      rbac = {
        count = 0
      }
      secrets = {
        count = 1
      }
    }

    ethereum_storage = {
      cert_manager = {
        count = 1
      }
      certificates = {
        count = 1
      }
      namespaces = {
        for_each = ["api", "ms", "observability", "cert-manager"]
      }
      networking = {
        count = 0
      }
      otel_operator = {
        count = 1
      }
      ethereum_pv = {
        count = 1
      }
      rbac = {
        count = 0
      }
      secrets = {
        count = 1
      }
    }

    up_till_cert_manager = {
      cert_manager = {
        count = 1
      }
      certificates = {
        count = 1
      }
      namespaces = {
        for_each = ["api", "ms", "observability", "cert-manager"]
      }
      networking = {
        count = 0
      }
      otel_operator = {
        count = 0
      }
      ethereum_pv = {
        count = 0
      }
      rbac = {
        count = 0
      }
      secrets = {
        count = 1
      }
    }
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
