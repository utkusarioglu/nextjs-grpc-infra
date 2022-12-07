# variable "project_root_path" {
#   type = string
# }

variable "helm_timeout_unit" {
  type = number
}

variable "helm_atomic" {
  type = bool
}

variable "deployment_mode" {
  type        = string
  description = "Specify a mode that determines which resources will be deployed. Example: 'all' deploys everything"
}

variable "sld" {
  type = string
}

variable "tld" {
  type = string
}

variable "secrets_path" {
  type        = string # path
  description = "Root path where the configuration secrets are kept"
}

variable "assets_path" {
  type        = string # path
  description = "Root path where the non-secrets assets for the configuration are kept"
}

variable "vault_subdomain" {
  type        = string # url subdomain
  description = "The subdomain from which the vault will be publicly exposed"
}
