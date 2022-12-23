dependencies {
  paths = [
    "../aws-config"
  ]
}

// dependency "aws_base" {
//   config_path = "../aws-base"
// }
dependency "aws_kms" {
  config_path = "../aws-kms"
}

dependency "aws_eks" {
  config_path = "../aws-eks"
}

include "root" {
  path = find_in_parent_folders()
}

include "config" {
  path = "${get_repo_root()}/configs//${basename(get_terragrunt_dir())}/config.hcl"
}

inputs = {
  platform_specific_vault_config = templatefile("${get_repo_root()}/assets/vault/vault.aws-kms-stanza.tftpl.hcl", {
    aws_kms_key_id_for_vault = dependency.aws_kms.outputs.aws_kms_key_id_for_vault
  })
}

generate "cluster_data" {
  path      = "data.cluster.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/TEMP_FOR_VAULT.hcl", {})
}


// generate "provider_helm_aws" {
//   path      = "provider.helm.aws.generated.tf"
//   if_exists = "overwrite"
//   contents  = <<-EOF
//     provider "helm" {
//       kubernetes {
//         host                   = "${dependency.aws_base.outputs.cluster_endpoint}"
//         cluster_ca_certificate = "${dependency.aws_base.outputs.cluster_ca_certificate}"
//         token                  = "${dependency.aws_base.outputs.cluster_token}"
//       }
//     }
//   EOF
// }

// generate "provider_kubernetes_aws" {
//   path      = "provider.kubernetes.aws.generated.tf"
//   if_exists = "overwrite"
//   contents  = <<-EOF
//     provider "kubernetes" {
//       host                   = "${dependency.aws_base.outputs.cluster_endpoint}"
//       cluster_ca_certificate = <<-EOT
//         ${dependency.aws_base.outputs.cluster_ca_certificate}
//       EOT
//       token                  = "${dependency.aws_base.outputs.cluster_token}"
//     }
//   EOF
// }
