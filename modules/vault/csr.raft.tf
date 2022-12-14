resource "kubernetes_certificate_signing_request_v1" "vault_raft_csr" {
  count = local.deployment_configs.vault.count

  metadata {
    name = "vault-raft-csr"
  }

  spec {
    usages = [
      "digital signature",
      "key encipherment",
      "server auth"
    ]
    request     = tls_cert_request.vault_raft_csr[0].cert_request_pem
    signer_name = "kubernetes.io/kubelet-serving"
  }

  auto_approve = true
}

resource "kubernetes_secret" "vault_raft_tls_cert" {
  count = local.deployment_configs.vault.count

  metadata {
    name      = "vault-raft-tls-cert"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.key" = tls_private_key.vault_raft_pk[0].private_key_pem
    "tls.crt" = join("", [
      kubernetes_certificate_signing_request_v1.vault_raft_csr[0].certificate,
      base64decode(data.external.ca.result.ca_crt)
    ])
    "ca.crt" = base64decode(data.external.ca.result.ca_crt)
  }
}
