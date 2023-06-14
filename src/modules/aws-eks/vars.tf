# create some variables
variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
}

variable "autoscaling_average_cpu" {
  type        = number
  description = "Average CPU threshold to auto-scale EKS EC2 instances."
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

variable "aws_vault_kms_unseal_policy_arn" {
  type        = string # arn
  description = "ARN for the policy that vault nodes need for unsealing through KMS"
}
