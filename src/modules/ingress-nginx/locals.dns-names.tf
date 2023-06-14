locals {
  base_dns_name = "${var.sld}.${var.tld}"
  subdomains = [
    var.grafana_subdomain,
    var.prometheus_subdomain,
    var.jaeger_subdomain,
    var.kubernetes_dashboard_subdomain,
    var.vault_subdomain,
  ]
  other_dns_names = [
    for subdomain in local.subdomains : "${subdomain}.${local.base_dns_name}"
  ]
  dns_names = concat([local.base_dns_name], local.other_dns_names)
}
