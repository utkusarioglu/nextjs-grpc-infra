# resource "kubernetes_certificate_signing_request_v1" "vault_api_csr" {
#   count = local.deployment_configs.vault.count

#   metadata {
#     name = "vault-api-csr"
#   }

#   spec {
#     usages = [
#       "digital signature",
#       "key encipherment",
#       "server auth"
#     ]
#     request     = tls_cert_request.vault_api_csr[0].cert_request_pem
#     signer_name = "kubernetes.io/kubelet-serving"
#   }

#   auto_approve = true
# }
