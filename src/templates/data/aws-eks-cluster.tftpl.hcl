data "aws_eks_cluster" "cluster" {
  name = "${cluster_name}"
}
