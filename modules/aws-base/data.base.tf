data "aws_caller_identity" "current" {} # used for accessing Account ID and ARN

data "aws_eks_cluster_auth" "this" {
  name = module.cluster.cluster_id
}

output "cluster_token" {
  value     = data.aws_eks_cluster_auth.this.token
  sensitive = true
}
