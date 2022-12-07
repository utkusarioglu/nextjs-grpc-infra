locals {
  # certificate_authority = {
  #   cert = file(".certs/intermediate/intermediate.crt")
  #   key  = file(".certs/intermediate/intermediate.key")
  # }

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
