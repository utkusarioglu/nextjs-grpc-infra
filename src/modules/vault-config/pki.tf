resource "vault_mount" "pki" {
  count                 = local.deployment_configs.vault_config.count
  type                  = "pki"
  path                  = "pki"
  max_lease_ttl_seconds = 365 * 24 * 60 * 60
}

resource "vault_pki_secret_backend_root_cert" "pki" {
  count              = local.deployment_configs.vault_config.count
  backend            = vault_mount.pki[0].path
  type               = "internal"
  common_name        = "Root CA"
  ttl                = "315360000"
  format             = "pem"
  private_key_format = "der"
  key_type           = "ec"
  key_bits           = 256
  # key_type             = "rsa"
  # key_bits             = 2048
  exclude_cn_from_sans = true
}

resource "vault_pki_secret_backend_config_urls" "pki" {
  backend = vault_mount.pki[0].path
  issuing_certificates = [
    "https://vault.vault:8200/v1/pki/ca",
  ]
  crl_distribution_points = [
    "https://vault.vault:8200/v1/pki/crl"
  ]
}

resource "vault_pki_secret_backend_role" "services" {
  count    = local.deployment_configs.vault_config.count
  backend  = vault_mount.pki[0].path
  name     = "services"
  ttl      = 3600
  key_type = "ec"
  key_bits = 256
  # key_type           = "rsa"
  # key_bits           = 2048
  allow_subdomains   = false
  require_cn         = false
  key_usage          = ["ServerAuth", "ClientAuth"]
  max_ttl            = 30 * 24 * 60 * 60
  generate_lease     = false
  allow_bare_domains = true
  allow_glob_domains = true
  allow_ip_sans      = true
  allow_localhost    = true

  allowed_domains = (
    [for ns in local.deployment_configs.namespaces.for_each : "*.${ns}"]
  )
}
