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

generate "vars_environment" {
  path      = "vars.environment.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.environment.tftpl.hcl", {})
}

generate "vars_ingress_sg" {
  path      = "vars.ingress-sg.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.ingress-sg.tftpl.hcl", {})
}

generate "vars_project" {
  path      = "vars.project.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.project.tftpl.hcl", {})
}

generate "vars_url" {
  path      = "vars.url.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.url.tftpl.hcl", {})
}
