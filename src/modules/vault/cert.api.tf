resource "tls_private_key" "vault_api_pk" {
  count = local.deployment_configs.vault.count

  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "vault_api_csr" {
  count = local.deployment_configs.vault.count

  private_key_pem = tls_private_key.vault_api_pk[0].private_key_pem

  subject {
    common_name  = "${var.vault_subdomain}.${var.sld}.${var.tld}"
    organization = var.project_name
  }

  dns_names = [
    "vault.${var.sld}.${var.tld}",
    "vault.vault",
    "vault.vault.svc",
    "*.vault-internal",
  ]

  ip_addresses = [
    "127.0.0.1"
  ]
}

resource "tls_locally_signed_cert" "vault_api" {
  count = local.deployment_configs.vault.count

  cert_request_pem   = tls_cert_request.vault_api_csr[0].cert_request_pem
  ca_cert_pem        = local.certs.vault.cert
  ca_private_key_pem = local.certs.vault.key

  validity_period_hours = 12

  allowed_uses = [
    "server_auth",
  ]
}

resource "kubernetes_secret" "vault_api_tls_cert" {
  count = local.deployment_configs.vault.count
  # for_each = toset(["ms", "vault"]) // this is going to break when a new cluster is being created

  metadata {
    name = "vault-api-tls-cert"
    # namespace = each.key
    # namespace = kubernetes_namespace.this.metadata[0].name
    namespace = var.vault_namespace
  }

  type = "kubernetes.io/tls"
  data = {
    "tls.key" = tls_private_key.vault_api_pk[0].private_key_pem
    "tls.crt" = join("", [
      tls_locally_signed_cert.vault_api[0].cert_pem,
      local.certs.vault.bundle
    ])
    "ca.crt" = local.certs.vault.ca
  }
}

resource "kubernetes_secret" "vault_api_tls_client" {
  # count = local.deployment_configs.vault.count
  for_each = toset(["ms", "observability"]) // this is going to break when a new cluster is being created

  metadata {
    name      = "vault-api-tls-client-ca"
    namespace = each.key
    # namespace = kubernetes_namespace.this.metadata[0].name
  }

  type = "kubernetes.io/secret"
  data = {
    # "tls.key" = tls_private_key.vault_api_pk[0].private_key_pem
    "tls.crt" = join("", [
      tls_locally_signed_cert.vault_api[0].cert_pem,
      local.certs.vault.bundle
    ])
    "ca.crt" = local.certs.vault.ca
  }
}
