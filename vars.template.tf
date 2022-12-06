variable "project_root_rel_path" {
  description = "Relative path that points to the first parent of all the repos that build up the project. Example: '../..'"
  type        = string
  default     = "."
}
