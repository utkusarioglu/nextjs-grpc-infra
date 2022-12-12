terraform {
  source = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}"
}

generate "providers" {
  path      = "provider.vault.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/provider.vault.tftpl.hcl", {})
}

generate "vars_deployment_config" {
  path      = "vars.deployment-config.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.deployment-config.tftpl.hcl", {})
}

generate "vars_paths" {
  path      = "vars.paths.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.paths.tftpl.hcl", {})
}
