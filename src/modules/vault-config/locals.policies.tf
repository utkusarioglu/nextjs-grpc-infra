locals {
  private_vault_policies_subpath = "vault/policies"
  private_vault_policies_rel_path = join("/", [
    var.configs_abspath,
    local.private_vault_policies_subpath,
  ])
  private_policy_rel_paths = fileset(
    local.private_vault_policies_rel_path,
    "**/*.policy.hcl"
  )
  private_policy_rel_path_name_mapping = {
    for rel_path in local.private_policy_rel_paths : rel_path => {
      "name" = replace(
        replace(
          trimsuffix(rel_path, ".policy.hcl"),
        "/", "_"),
      "-", "_")
    }
  }
  policy_records = {
    for rel_path in local.private_policy_rel_paths
    : local.private_policy_rel_path_name_mapping[rel_path].name => {
      "rel_path" = rel_path,
      "name"     = local.private_policy_rel_path_name_mapping[rel_path].name
      "content"  = file("${local.private_vault_policies_rel_path}/${rel_path}")
    }
  }
}
