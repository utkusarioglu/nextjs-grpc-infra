include "repo" {
  path   = find_in_parent_folders("terragrunt.repo.hcl")
  expose = true
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
    "../k8s-namespaces",
    "../vault",
    "../aws-route53-for-vault"
  ]
}

locals {
  remote_state_target_helper_hcl = read_terragrunt_config("./remote-state.target.aws.helper.hcl")
  remote_state_config            = local.remote_state_target_helper_hcl.locals.remote_state_config
}

remote_state {
  backend = "s3"
  config  = local.remote_state_config
}

// locals {
//   parents = {
//     for parent in ["region"] :
//     parent => read_terragrunt_config(
//       find_in_parent_folders("terragrunt.${parent}.hcl")
//     )
//   }

//   region            = local.parents.region.inputs.region
//   aws_profile       = local.parents.region.inputs.aws_profile
//   region_identifier = local.parents.region.inputs.region_identifier
//   cluster_name      = local.parents.region.inputs.cluster_name

//   target_identifier = concat(local.region_identifier, [
//     basename(get_terragrunt_dir())
//   ])
//   target_name = join("-", local.target_identifier)
//   s3_key      = join("/", concat(local.target_identifier, ["terraform.tfstate"]))

//   remote_state_config = {
//     bucket         = local.target_name
//     key            = local.s3_key
//     region         = local.region
//     encrypt        = true
//     dynamodb_table = local.target_name
//     profile        = local.aws_profile
//   }

//   config_templates = {
//     backends = [
//       {
//         name = "aws"
//         args = local.remote_state_config
//       }
//     ]
//     providers = [
//       {
//         name = "aws-helm-kubernetes"
//         args = {
//           cluster_name = local.cluster_name
//         }
//       }
//     ]
//   }
// }

// remote_state {
//   backend = "s3"
//   config  = local.remote_state_config
// }

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
