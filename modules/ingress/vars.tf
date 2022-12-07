variable "project_root_path" {
  type = string
}

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
