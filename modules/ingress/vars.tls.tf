variable "intermediate_crt_path" {
  type        = string
  description = "Intermediate certificate"
  sensitive   = true
}

variable "intermediate_key_path" {
  type        = string
  description = "Intermediate certificate key"
  sensitive   = true
}
