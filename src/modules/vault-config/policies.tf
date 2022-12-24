# # Create admin policy in the root namespace
# resource "vault_policy" "admin_policy" {
#   count  = local.deployment_configs.vault.count
#   name   = "admin"
#   policy = file("${var.assets_path}/policies/admin-policy.hcl")
# }

# # Create 'training' policy
# resource "vault_policy" "eaas-client" {
#   count  = local.deployment_configs.vault.count
#   name   = "eaas-client"
#   policy = file("${var.assets_path}/policies/eaas-client-policy.hcl")
# }

# resource "vault_policy" "web_app" {
#   count  = local.deployment_configs.vault.count
#   name   = "web_app"
#   policy = file("${var.assets_path}/policies/web-app.policy.hcl")
# }

resource "vault_policy" "all" {
  for_each = (
    local.deployment_configs.vault.count == 0
    ? [] :
    fileset("${var.assets_path}", "vault/policies/*.policy.hcl")
  )
  name   = replace(trimsuffix(basename(each.key), ".policy.hcl"), "-", "_")
  policy = file("${var.assets_path}/${each.key}")
}
