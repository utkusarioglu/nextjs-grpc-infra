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

dependencies {
  paths = [
    // target-dependent
    "../k3d-cluster",

    // target-independent
    "../k8s-namespaces",
    "../operators",
    "../vault",
    "../vault-config",
    "../vault-for-databases",
    "../databases"
  ]
}

inputs = {
  ingress_sg = "<DOES_NOT_APPLY_IN_K3D>"
}
