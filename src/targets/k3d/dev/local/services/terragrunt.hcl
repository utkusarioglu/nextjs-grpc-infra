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
  path = "./terragrunt.logic.hcl"
}

dependencies {
  paths = [
    "../k3d-cluster",
    "../k8s-namespaces",
    "../k8s-config",
    "../observability",
    "../cert-manager",
    "../vault-config",
    "../databases",
    "../vault-for-databases"
    // there is more to add here
  ]
}

inputs = {
  web_server_image_tag = get_env("WEB_SERVER_IMAGE_TAG", "")
  ms_image_tag         = get_env("MS_IMAGE_TAG", "")
  ingress_sg           = "DOES_NOT_APPLY_IN_K3D"
}
