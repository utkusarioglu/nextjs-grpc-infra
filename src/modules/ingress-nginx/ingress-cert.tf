resource "tls_private_key" "ingress_pk" {
  count       = local.deployment_configs.ingress.count
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "ingress_cert_req" {
  count           = local.deployment_configs.ingress.count
  private_key_pem = tls_private_key.ingress_pk[0].private_key_pem

  subject {
    country      = "UT"
    province     = "UT"
    locality     = "UT"
    organization = var.project_name
  }

  dns_names = local.dns_names
}

resource "tls_locally_signed_cert" "ingress_cert" {
  count              = local.deployment_configs.ingress.count
  cert_request_pem   = tls_cert_request.ingress_cert_req[0].cert_request_pem
  ca_private_key_pem = local.intermediate_key
  ca_cert_pem        = local.intermediate_crt

  validity_period_hours = 24

  allowed_uses = [
    "server_auth",
  ]
}

resource "kubernetes_secret" "ingress_server_cert" {
  count = local.deployment_configs.ingress.count

  metadata {
    name      = "ingress-server-cert"
    namespace = local.ingress_namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "ca.crt"  = local.intermediate_crt
    "tls.key" = tls_private_key.ingress_pk[0].private_key_pem
    "tls.crt" = join("", [
      tls_locally_signed_cert.ingress_cert[0].cert_pem,
      local.intermediate_crt
    ])
  }
}
