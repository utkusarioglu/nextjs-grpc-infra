output "aws_alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "aws_vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "aws_vpc_vpc_id" {
  value = module.vpc.vpc_id
}
