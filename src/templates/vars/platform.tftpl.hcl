variable "platform" {
  description = "The platform in which the cluster is being provisioned"
  type        = string

  validation {
    condition     = contains(["k3d", "aws"], var.platform)
    error_message = "Allowed values for variable `platform` are: local, aws"
  }
}
