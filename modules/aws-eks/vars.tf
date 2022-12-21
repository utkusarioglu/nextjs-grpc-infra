# create some variables
variable "eks_managed_node_groups" {
  type        = map(any)
  description = "Map of EKS managed node group definitions to create"
}

variable "autoscaling_average_cpu" {
  type        = number
  description = "Average CPU threshold to autoscale EKS EC2 instances."
}

variable "cluster_version" {
  type = string
}

variable "aws_vpc_private_subnets" {
  type = list(string)
}

variable "aws_vpc_vpc_id" {
  type = string
}

variable "aws_alb_security_group_id" {
  type = string
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}
