locals {
  constants = read_terragrunt_config(join("/", [
    get_repo_root(),
    "constants.repo.hcl"
  ])).locals

  module_hierarchy = local.constants.module_hierarchy
  targets_path     = local.constants.targets_path
  modules_path     = local.constants.modules_path

  target_parts = split(
    "/",
    trimprefix(get_path_from_repo_root(),
    "${local.targets_path}/")
  )
  module_depth     = length(local.target_parts)
  module_ancestors = slice(local.module_hierarchy, 0, local.module_depth + 1)
  module_descendants = slice(
    local.module_hierarchy,
    local.module_depth,
    length(local.module_hierarchy)
  )
  module_role = local.module_descendants[0]

  parents_map = zipmap(
    local.module_ancestors,
    flatten(["repo", local.target_parts])
  )

  template_types = local.constants.template_types

  parents = merge({
    for parent_type, parent_name in local.parents_map :
    parent_type => contains(local.module_descendants, parent_type)
    ? null
    : read_terragrunt_config(
      find_in_parent_folders("terragrunt.${parent_type}.hcl")
    )
    },

    local.module_role == "target"
    ? {
      module = read_terragrunt_config(join("/", [
        get_repo_root(),
        local.modules_path,
        basename(get_terragrunt_dir()),
        "terragrunt.module.hcl"
        ])
      )
    }
    : {}
  )
}
