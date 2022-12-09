variable "intermediate_key_path" {
  type        = string
  description = "key for the tls cert for Vault Api"
  sensitive   = true
}
