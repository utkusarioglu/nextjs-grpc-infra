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

include "logic" {
  path = "./logic.target.k3d.helper.hcl"
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

inputs = {
  vault_kubernetes_mount_path = dependency.vault_config.outputs.vault_kubernetes_mount_path
}
