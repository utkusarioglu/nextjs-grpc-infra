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

locals {
  k3d_config_path        = "${get_repo_root()}/src/configs/k3d.config.yml"
  destroy_cluster_action = "delete" // or stop

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
  cluster_name = local.parents.region.locals.cluster_name
}

terraform {
  before_hook "check_requirements" {
    commands = [
      "apply",
      "plan"
    ]
    execute = [
      "scripts/check-requirements.sh",
      "${get_repo_root()}"
    ]
  }

  before_hook "start_k3d_cluster" {
    commands = [
      "apply",
      "plan"
    ]
    execute = [
      "scripts/start-k3d-cluster.sh",
      local.cluster_name,
      local.k3d_config_path
    ]
  }

  // Needed by Vault 
  after_hook "retrieve_ca_crt_file" {
    commands = ["plan", "apply"]
    execute = [
      "scripts/kubectl-get-cluster-ca.sh",
      "${get_repo_root()}/artifacts/cluster-ca/cluster-ca.crt"
    ]
  }

  after_hook "stop_k3d_cluster" {
    commands = [
      "plan",
      "destroy"
    ]
    working_dir = "${get_repo_root()}/src/configs"
    execute = [
      "k3d",
      "cluster",
      local.destroy_cluster_action,
      local.cluster_name
    ]
  }

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
