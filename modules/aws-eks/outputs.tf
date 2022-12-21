output "cluster_token" {
  value     = data.aws_eks_cluster_auth.this.token
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
  # value = base64decode(module.cluster.)
}
