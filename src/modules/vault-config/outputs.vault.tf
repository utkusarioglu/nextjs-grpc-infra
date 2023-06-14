output "vault_kubernetes_auth_backend" {
  value       = vault_auth_backend.kubernetes[0].path
  description = "Kubernetes backend for vault"
}
