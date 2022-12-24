variable "project_root_path" {
  type    = string
  default = "/utkusarioglu-com/projects/nextjs-grpc"
}

variable "cluster_name" {
  description = "The name for the cluster that is being created on eks"
  type        = string
  nullable    = false

  validation {
    condition     = var.cluster_name != "<cluster_name>"
    error_message = "tfvars `cluster_name` attribute has to be set to the desired cluster name"
  }
}
