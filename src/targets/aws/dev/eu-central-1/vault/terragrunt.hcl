include "repo" {
  path = find_in_parent_folders("terragrunt.repo.hcl")
}

include "platform" {
  path = find_in_parent_folders("terragrunt.platform.hcl")
}

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

include "generate" {
  path = "./generate.target.aws.helper.hcl"
}

include "hooks" {
  path = "./hooks.target.aws.helper.hcl"
}

dependencies {
  paths = [
    "../aws-config",
    "../k8s-namespaces",
    "../aws-ebs-volumes",
  ]
}

dependency "aws_kms" {
  config_path = "../aws-kms"

  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    aws_kms_key_id_for_vault = "mock"
  }
}

dependency "aws_eks" {
  config_path = "../aws-eks"

  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    cluster_ca_certificate = "mock"
  }
}

dependency "aws_vpc" {
  config_path = "../aws-vpc"

  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    aws_alb_security_group_id = "mock"
  }
}


locals {
  // parents = {
  //   for parent in ["repo", "region"] :
  //   parent => read_terragrunt_config(
  //     find_in_parent_folders("terragrunt.${parent}.hcl")
  //   )
  // }

  // artifacts_abspath = local.parents.repo.inputs.artifacts_abspath
  // region            = local.parents.region.inputs.region
  // aws_profile       = local.parents.region.inputs.aws_profile
  // region_identifier = local.parents.region.inputs.region_identifier
  // cluster_name      = local.parents.region.inputs.cluster_name

  // target_identifier = concat(local.region_identifier, [
  //   basename(get_terragrunt_dir())
  // ])
  // target_name = join("-", local.target_identifier)
  // s3_key      = join("/", concat(local.target_identifier, ["terraform.tfstate"]))

  // remote_state_config = {
  //   bucket         = local.target_name
  //   key            = local.s3_key
  //   region         = local.region
  //   encrypt        = true
  //   dynamodb_table = local.target_name
  //   profile        = local.aws_profile
  // }

  // config_templates = {
  //   backends = [
  //     {
  //       name = "aws"
  //       args = local.remote_state_config
  //     }
  //   ]
  //   providers = [
  //     {
  //       name = "aws-helm-kubernetes"
  //       args = {
  //         cluster_name = local.cluster_name
  //       }
  //     }
  //   ]
  // }
  lineage_helper_hcl = read_terragrunt_config("./lineage.helper.hcl")
  parents            = local.lineage_helper_hcl.locals.parents
  region             = local.parents.region.locals.region
  artifacts_abspath  = local.parents.repo.inputs.artifacts_abspath

  remote_state_target_helper_hcl = read_terragrunt_config("./remote-state.target.aws.helper.hcl")
  remote_state_config            = local.remote_state_target_helper_hcl.locals.remote_state_config

  vault_artifacts_abspath = "${local.artifacts_abspath}/vault/aws"
}

remote_state {
  backend = "s3"
  config  = local.remote_state_config
}

// generate "generated_config_target" {
//   path      = "generated-config.target.tf"
//   if_exists = "overwrite"
//   contents = join("\n", ([
//     for key, items in local.config_templates :
//     (join("\n", [
//       for j, template in items :
//       templatefile(
//         "${get_repo_root()}/src/templates/${key}/${template.name}.tftpl.hcl",
//         try(template.args, {})
//       )
//     ]))
//   ]))
// }

inputs = {
  platform_specific_vault_config = templatefile(
    "${get_repo_root()}/src/configs/vault/vault.aws-kms-stanza.tftpl.hcl",
    {
      aws_kms_key_id_for_vault   = dependency.aws_kms.outputs.aws_kms_key_id_for_vault
      vault_token_via_agent_path = "/vault/vault-token-via-agent"
      // listed in `aws-iam-tfvars` not sure if it will work
      aws_role_for_vault_auth = "vault-auth"
      region                  = local.region
    }
  )
  vault_namespace    = "vault"
  cluster_ca_crt_b64 = base64encode(dependency.aws_eks.outputs.cluster_ca_certificate)

  // TODO not clear if this is needed
  ingress_sg = dependency.aws_vpc.outputs.aws_alb_security_group_id

  // TODO get rid of these
  intermediate_crt_b64 = base64encode(file("${get_repo_root()}/.certs/intermediate/tls.crt"))
  intermediate_key_b64 = base64encode(file("${get_repo_root()}/.certs/intermediate/tls.key"))
  ca_crt_b64           = base64encode(file("${get_repo_root()}/.certs/intermediate/ca.crt"))
}

terraform {
  after_hook "vault_operator_init" {
    commands = ["apply"]
    execute = [
      "scripts/vault-operator-init.sh",
      local.vault_artifacts_abspath
    ]
    run_on_error = false
  }
}
