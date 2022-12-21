dependencies {
  paths = [
    "../aws-vpc"
  ]
}

dependency "aws_vpc" {
  config_path = "../aws-vpc"
}

include "eu_central_1" {
  path = "../terragrunt.hcl"
}

include "config" {
  path = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}/terragrunt.hcl"
}

inputs = {
  // cluster_name              = include.eu_central_1.inputs.cluster_name
  aws_vpc_private_subnets   = dependency.aws_vpc.outputs.aws_vpc_private_subnets
  aws_vpc_vpc_id            = dependency.aws_vpc.outputs.aws_vpc_vpc_id
  aws_alb_security_group_id = dependency.aws_vpc.outputs.aws_alb_security_group_id
}
