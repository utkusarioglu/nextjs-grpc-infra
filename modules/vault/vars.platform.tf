variable "platform" {
  type        = string
  description = "Name of the platform on which the module is provisioned"

  validation {
    condition     = contains(["aws", "k3d"], var.platform)
    error_message = "Unrecognized platform. Supported platforms for this module: aws, k3d"
  }
}

variable "platform_specific_vault_config" {
  type        = string
  description = "platform specific configuration snippet to add to vault config file"
}
