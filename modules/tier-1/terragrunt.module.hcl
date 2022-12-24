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

generate "vars_tls_ca_cert" {
  path      = "vars.tls-ca-cert.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.tls-ca-cert.tftpl.hcl", {})
}

generate "vars_tls_intermediate_cert" {
  path      = "vars.tls-intermediate-cert.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.tls-intermediate-cert.tftpl.hcl", {})
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

generate "vars_volumes" {
  path      = "vars.volumes.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.volumes.tftpl.hcl", {})
}
