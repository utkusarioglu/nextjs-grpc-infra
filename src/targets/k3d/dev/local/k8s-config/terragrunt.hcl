include "repo" {
  path = find_in_parent_folders("terragrunt.repo.hcl")
}

include "platform" {
  path = find_in_parent_folders("terragrunt.platform.hcl")
}

include "region" {
  path = find_in_parent_folders("terragrunt.region.hcl")
}

include "module" {
  path = join("/", [
    get_repo_root(),
    "src/modules/",
    basename(get_terragrunt_dir()),
    "terragrunt.module.hcl"
  ])
}

dependency "vault_config" {
  config_path = "../vault-config"
  
  mock_outputs = {
    vault_kubernetes_mount_path = "mock"   
  }

  mock_outputs_allowed_terraform_commands = ["validate"] 
}

dependencies {
  paths = [
    "../k3d-cluster",
    "../k8s-namespaces",
    "../k3d-volumes", // postgres storage needs this
    "../cert-manager",
    "../vault-config"
  ]
}

locals {
  parent_precedence = ["repo", "platform", "environment", "region"]
  template_types = [
    "required_providers",
    "providers",
    "backends",
    "data",
    "locals",
    "vars"
  ]

  parents = merge({
    for parent in local.parent_precedence :
    parent => read_terragrunt_config(
      find_in_parent_folders("terragrunt.${parent}.hcl")
    )
    }, {
    module = read_terragrunt_config(join("/", [
      get_repo_root(),
      "src/modules/",
      basename(get_terragrunt_dir()),
      "terragrunt.module.hcl"
      ])
    )
  })
  aggregated_config_templates = {
    for template_type in local.template_types :
    template_type => flatten([
      for parent in flatten([local.parent_precedence, "module"]) :
      try(local.parents[parent].locals.config_templates[template_type], [])
    ])
  }
}

inputs = {
  vault_kubernetes_mount_path = dependency.vault_config.outputs.vault_kubernetes_mount_path
}

terraform {
  after_hook "validate_tflint" {
    commands = ["validate"]
    execute  = ["sh", "-c", "tflint --config=.tflint.hcl -f default || true"]
  }
}

generate "generated_config_target" {
  path      = "aggregated_config_templates.tf"
  if_exists = "overwrite"
  contents = join("\n\n", ([
    for key, items in local.aggregated_config_templates :
    (
      templatefile(
        "${get_repo_root()}/src/templates/wrappers/${key}.tftpl.hcl", {
          contents = join("\n", [
            for j, template in items :
            templatefile(
              "${get_repo_root()}/src/templates/${key}/${template.name}.tftpl.hcl",
              try(template.args, {})
            )
          ])
        }
      )
    )
  ]))
}
