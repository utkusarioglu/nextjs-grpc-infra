terraform {
  source = "${get_repo_root()}/src/modules//${basename(get_terragrunt_dir())}"

  extra_arguments "vault_vars" {
    commands = [
      "apply",
      "plan",
      "destroy",
    ]
    required_var_files = [
      "${get_repo_root()}/vars/aws-spot-termination-handler.tfvars",
      "${get_repo_root()}/vars/aws-external-dns.tfvars",
      "${get_repo_root()}/vars/aws-vpc.tfvars", // name_prefix
      "${get_repo_root()}/vars/aws-iam.tfvars",
      "${get_repo_root()}/vars/aws-ingress.tfvars",
      // "${get_repo_root()}/vars/${basename(get_terragrunt_dir())}.common.tfvars"
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
