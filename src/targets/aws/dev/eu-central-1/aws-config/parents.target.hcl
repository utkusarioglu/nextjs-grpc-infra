locals {
  constants = read_terragrunt_config(join("/", [
    get_repo_root(),
    "constants.repo.hcl"
  ])).locals

  parent_precedence = local.constants.parent_precedence
  template_types    = local.constants.template_types

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
}
