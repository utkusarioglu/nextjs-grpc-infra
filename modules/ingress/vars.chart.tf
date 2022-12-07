variable "ingress_nginx_chart_name" {
  type        = string
  description = "Name of the ingress resource"
}

variable "ingress_nginx_chart_chart" {
  type        = string
  description = "Resource chart name"
}

variable "ingress_nginx_chart_repository" {
  type        = string
  description = "Url of the repository of the chart"
}

variable "ingress_nginx_chart_version" {
  type        = string
  description = "Version for the resource"
}
