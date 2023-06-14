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
    "../k3d-cluster",
  ]
}
