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

variable "intermediate_crt" {
  type        = string
  description = "Intermediate certificate"
}

variable "intermediate_key" {
  type        = string
  description = "Intermediate certificate key"
}
