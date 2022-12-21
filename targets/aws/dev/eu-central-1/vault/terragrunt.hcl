dependencies {
  paths = [
    "../aws-config"
  ]
}

// dependency "aws_base" {
//   config_path = "../aws-base"
// }

include "root" {
  path = find_in_parent_folders()
}

include "config" {
  path = "${get_repo_root()}/configs//${basename(get_terragrunt_dir())}/config.hcl"
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
