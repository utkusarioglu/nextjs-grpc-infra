locals {
  deployment_config_presets = {
    all = {
      api = {
        count = 1
      }
      grafana = {
        count = 1
      }
      jaeger_operator = {
        count = 1
      }
      loki = {
        count = 1
      }
      ms = {
        count = 1
      }
      otel_collectors = {
        count = 1
      }
      ethereum_pvc = {
        count = 1
      }
      ethereum_storage = {
        count = 1
      }
      prometheus = {
        count = 1
      }
      kubernetes_dashboard = {
        count = 1
      }
    }

    up_till_cert_manager = {
      api = {
        count = 0
      }
      grafana = {
        count = 0
      }
      jaeger_operator = {
        count = 0
      }
      loki = {
        count = 0
      }
      ms = {
        count = 0
      }
      otel_collectors = {
        count = 0
      }
      ethereum_pvc = {
        count = 0
      }
      ethereum_storage = {
        count = 0
      }
      prometheus = {
        count = 0
      }
      kubernetes_dashboard = {
        count = 0
      }
    }

    ethereum_storage = {
      api = {
        count = 0
      }
      grafana = {
        count = 1
      }
      jaeger_operator = {
        count = 1
      }
      loki = {
        count = 1
      }
      ms = {
        count = 0
      }
      otel_collectors = {
        count = 1
      }
      ethereum_pvc = {
        count = 1
      }
      ethereum_storage = {
        count = 1
      }
      prometheus = {
        count = 1
      }
      kubernetes_dashboard = {
        count = 0
      }
    }
  }

  deployment_configs = local.deployment_config_presets[var.deployment_mode]
}
