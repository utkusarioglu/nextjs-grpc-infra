variable "secrets_abspath" {
  type        = string # path
  description = "Root path where the configuration secrets are kept"
}

variable "configs_abspath" {
  type        = string # path
  description = "Root path where the non-secrets assets for the configuration are kept"
}
