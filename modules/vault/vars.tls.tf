variable "intermediate_key_path" {
  type        = string
  description = "key for the tls cert for Vault Api"
  sensitive   = true
}

variable "intermediate_crt_path" {
  type        = string
  description = "cert for Vault Api"
  sensitive   = true
}

variable "ca_crt_path" {
  type        = string
  description = "CA for the Vault Api"
  sensitive   = true
}
