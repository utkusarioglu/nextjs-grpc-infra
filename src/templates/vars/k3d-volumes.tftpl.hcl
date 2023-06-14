variable "nodes_volumes_root" {
  type        = string
  description = "Root folder for all the persistent volumes attached to nodes"
}

variable "nodes_source_code_root" {
  type        = string
  description = "Root folder at which nodes have the source code attached"
}
