variable "ca_crt_b64" {
  type        = string
  description = "Base64 encoded CA for the Vault Api"
  sensitive   = true
}
