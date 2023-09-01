locals {
  lineage_helper = read_terragrunt_config("./lineage.helper.hcl")
  parents        = local.lineage_helper.locals.parents
  cluster_name   = local.parents.region.inputs.cluster_name

  remote_state_target_helper = read_terragrunt_config("./remote-state.target.aws.helper.hcl")
  remote_state_config        = local.remote_state_target_helper.locals.remote_state_config

  config_templates = {
    backends = [
      {
        name = "aws"
        args = local.remote_state_config
      }
    ]

    // these aren't needed until aws-config
    data = [
      {
        name = "aws-eks-cluster"
        args = {
          cluster_name = local.cluster_name
        }
      },
      {
        name = "aws-eks-cluster-auth"
        args = {
          cluster_name = local.cluster_name
        }
      },
    ]

    // these aren't needed until aws-config
    providers = [
      {
        name = "aws-helm"
        args = {
          cluster_name = local.cluster_name
        }
      },
      {
        name = "aws-kubernetes"
        args = {
          cluster_name = local.cluster_name
        }
      }
    ]
  }
}
