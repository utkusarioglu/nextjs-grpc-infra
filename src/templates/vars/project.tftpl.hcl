variable "project_root_abspath" {
  description = "Root path of the project that owns this entire repo"
  type        = string
  nullable    = false
}

variable "project_name" {
  description = "The name for the cluster that is being created on eks"
  type        = string
  nullable    = false
}
