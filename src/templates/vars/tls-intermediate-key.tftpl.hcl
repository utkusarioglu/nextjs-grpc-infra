variable "intermediate_key_b64" {
  type        = string
  description = "Base 64 encoded key for the tls cert for Vault Api"
  sensitive   = true
}
