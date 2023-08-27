include "repo" {
  path = find_in_parent_folders("terragrunt.repo.hcl")
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

include "logic" {
  path = "./logic.target.k3d.helper.hcl"
}

dependency "vault_config" {
  config_path = "../vault-config"

  mock_outputs = {
    vault_secrets_mount_path = "mock"
  }

  mock_outputs_allowed_terraform_commands = ["validate"]
}

dependencies {
  paths = [
    // target-dependent
    "../k3d-cluster",

    // target-independent
    "../k8s-namespaces",
    "../vault",
    "../vault-config",
    "../databases",
  ]
}

inputs = {
  vault_secrets_mount_path = dependency.vault_config.outputs.vault_secrets_mount_path
}
