output "cluster_token" {
  value     = module.cluster.cluster_id
  sensitive = true
}

output "cluster_id" {
  value = module.cluster.cluster_id
}

output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
}

output "cluster_ca_certificate" {
  value = base64decode(module.cluster.cluster_certificate_authority_data)
}

output "cluster_oidc_provider_arn" {
  value = module.cluster.oidc_provider_arn
}
