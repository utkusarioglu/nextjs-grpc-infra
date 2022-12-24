terraform {
  source = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}"

  extra_arguments "vault_vars" {
    commands = [
      "apply",
      "plan",
      "destroy",
    ]
    required_var_files = [
      "${get_repo_root()}/vars/common.tfvars",
      "${get_repo_root()}/vars/${basename(get_terragrunt_dir())}.common.tfvars"
    ]
  }
}
