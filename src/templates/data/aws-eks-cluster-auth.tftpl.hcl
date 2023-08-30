data "aws_eks_cluster_auth" "cluster" {
  name = "${cluster_name}"
}
