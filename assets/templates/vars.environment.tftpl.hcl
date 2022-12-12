variable "environment" {
  description = "The environment in which the cluster is being provisioned"
  type        = string

  validation {
    condition     = contains(["local", "aws"], var.environment)
    error_message = "Allowed values for variable `environment` are: local, aws"
  }
}
