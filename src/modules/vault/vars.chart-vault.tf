variable "vault_resource_name" {
  type        = string
  description = "Name chosen for the vault instance in the cluster"
}

variable "vault_resource_repository" {
  type        = string
  description = "Repository for the vault chart"
}

variable "vault_resource_chart" {
  type        = string
  description = "Chart name for the Vault resource"
}

variable "vault_resource_version" {
  type        = string
  description = "Vault resource version"
}
