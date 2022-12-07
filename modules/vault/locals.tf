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

  certs = {
    vault = {
      key  = file(var.intermediate_key_path)
      cert = file(var.intermediate_crt_path)
      ca   = file(var.ca_crt_path)

      bundle = join("", [
        file(var.intermediate_crt_path),
        file(var.ca_crt_path)
      ])
    }
  }
}

# file(".certs/intermediate/intermediate.crt"),
# file(".certs/root/root.crt"),
