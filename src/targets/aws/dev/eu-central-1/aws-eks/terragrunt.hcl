include "region" {
  path = find_in_parent_folders("terragrunt.region.hcl")
}

include "module" {
  path = join("/", [
    get_repo_root(),
    "src/modules/",
    basename(get_terragrunt_dir()),
    "terragrunt.module.hcl"
  ])
}

dependencies {
  paths = [
    "../aws-vpc",
  ]
}

dependency "aws_vpc" {
  config_path = "../aws-vpc"
}

dependency "aws_kms" {
  config_path = "../aws-kms"
}

locals {
  parents = {
    for parent in ["region"] :
    parent => read_terragrunt_config(
      find_in_parent_folders("terragrunt.${parent}.hcl")
    )
  }

  region            = local.parents.region.inputs.region
  aws_profile       = local.parents.region.inputs.aws_profile
  region_identifier = local.parents.region.inputs.region_identifier
  cluster_name      = local.parents.region.inputs.cluster_name

  target_identifier = concat(local.region_identifier, [
    basename(get_terragrunt_dir())
  ])
  target_name = join("-", local.target_identifier)
  s3_key      = join("/", concat(local.target_identifier, ["terraform.tfstate"]))

  remote_state_config = {
    bucket         = local.target_name
    key            = local.s3_key
    region         = local.region
    encrypt        = true
    dynamodb_table = local.target_name
    profile        = local.aws_profile
  }

  config_templates = {
    backends = [
      {
        name = "aws"
        args = local.remote_state_config
      }
    ]
  }
}

remote_state {
  backend = "s3"
  config  = local.remote_state_config
}

generate "generated_config_target" {
  path      = "generated-config.target.tf"
  if_exists = "overwrite"
  contents = join("\n", ([
    for key, items in local.config_templates :
    (join("\n", [
      for j, template in items :
      templatefile(
        "${get_repo_root()}/src/templates/${key}/${template.name}.tftpl.hcl",
        try(template.args, {})
      )
    ]))
  ]))
}

inputs = {
  aws_vpc_private_subnets         = dependency.aws_vpc.outputs.aws_vpc_private_subnets
  aws_vpc_vpc_id                  = dependency.aws_vpc.outputs.aws_vpc_vpc_id
  aws_alb_security_group_id       = dependency.aws_vpc.outputs.aws_alb_security_group_id
  aws_vault_kms_unseal_policy_arn = dependency.aws_kms.outputs.aws_vault_kms_unseal_policy_arn
}

terraform {
  after_hook "update_kubeconfig" {
    commands = [
      "apply"
    ]
    execute = [
      "scripts/update-kubeconfig.sh",
      local.cluster_name,
      local.region,
      local.aws_profile
    ]
    run_on_error = false
  }

  after_hook "remove_kubeconfig" {
    commands = [
      "destroy"
    ]
    execute = [
      "scripts/remove-kubeconfig.sh",
      local.cluster_name,
      local.region,
    ]
    run_on_error = false
  }
}
