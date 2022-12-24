terraform {
  source = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}"
}

generate "vars_helm" {
  path      = "vars.helm.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.helm.tftpl.hcl", {})
}

generate "vars_deployment_config" {
  path      = "vars.deployment-config.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.deployment-config.tftpl.hcl", {})
}
