terraform {
  source = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}"

  extra_arguments "vault_vars" {
    commands = [
      "apply",
      "plan",
      "destroy",
    ]
    required_var_files = [
      "${get_repo_root()}/vars/aws-vpc.tfvars",
      // "${get_repo_root()}/vars/aws/aws-base.common.tfvars",
      // "${get_repo_root()}/vars/aws/eks.base.dev.tfvars",
      // "${get_repo_root()}/vars/aws/eks.config.dev.tfvars",
      // "${get_repo_root()}/vars/aws/external-dns.config.dev.tfvars",
      // "${get_repo_root()}/vars/aws/iam.config.dev.tfvars",
      // "${get_repo_root()}/vars/aws/ingress.config.dev.tfvars",
      // "${get_repo_root()}/vars/aws/network.base.dev.tfvars",
    ]
  }
}
