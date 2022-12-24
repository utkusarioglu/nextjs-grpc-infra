resource "tls_private_key" "vault_raft_pk" {
  count = local.deployment_configs.vault.count

  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "vault_raft_csr" {
  count = local.deployment_configs.vault.count

  private_key_pem = tls_private_key.vault_raft_pk[0].private_key_pem

  subject {
    common_name  = "system:node:vault-raft"
    organization = "system:nodes"
  }

  dns_names = [
    "vault",
    "vault.${kubernetes_namespace.this.metadata[0].name}",
    "vault.${kubernetes_namespace.this.metadata[0].name}.svc",
    "vault.${kubernetes_namespace.this.metadata[0].name}.svc.cluster.local",
    "*.vault-internal",
    "*.vault-internal.svc",
    "*.vault-internal.svc.cluster.local",
  ]

  ip_addresses = [
    "127.0.0.1"
  ]
}
