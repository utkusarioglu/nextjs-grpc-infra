variable "kubernetes_dashboard_subdomain" {
  description = "The subdomain under which kubernetes dashboard will be exposed publicly. Ex: kubernetes-dashboard of 'kubernetes-dashboard.website.com'"
  type        = string
}

variable "prometheus_subdomain" {
  description = "The subdomain under which prometheus will be exposed publicly. Ex: prometheus of 'prometheus.website.com'"
  type        = string
}

variable "jaeger_subdomain" {
  description = "The subdomain under which jaeger will be exposed publicly. Ex: jaeger of 'jaeger.website.com'"
  type        = string
}

variable "grafana_subdomain" {
  description = "The subdomain under which grafana will be exposed publicly. Ex: grafana of 'grafana.website.com'"
  type        = string
}
