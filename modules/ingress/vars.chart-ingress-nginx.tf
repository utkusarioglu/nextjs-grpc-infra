variable "ingress_nginx_resource_name" {
  type        = string
  description = "Name of the ingress resource"
}

variable "ingress_nginx_resource_chart" {
  type        = string
  description = "Resource resource name"
}

variable "ingress_nginx_resource_repository" {
  type        = string
  description = "Url of the repository of the resource"
}

variable "ingress_nginx_resource_version" {
  type        = string
  description = "Version for the resource"
}
