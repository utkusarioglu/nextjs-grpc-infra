terraform {
  source = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}"
}
