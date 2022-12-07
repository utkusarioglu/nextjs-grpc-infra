variable "secrets_path" {
  type        = string # path
  description = "Root path where the configuration secrets are kept"
}

variable "assets_path" {
  type        = string # path
  description = "Root path where the non-secrets assets for the configuration are kept"
}
