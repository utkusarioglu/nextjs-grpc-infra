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
    "../k3d-cluster",
    "../k8s-namespaces",
    "../k3d-volumes",
  ]
}

locals {
  parents = {
    for parent in ["repo"] :
    parent => read_terragrunt_config(
      find_in_parent_folders("terragrunt.${parent}.hcl")
    )
  }

  artifacts_abspath       = local.parents.repo.inputs.artifacts_abspath
  vault_artifacts_abspath = "${local.artifacts_abspath}/vault/k3d"

  // config_templates = {
  //   vars = [
  //     {
  //       name = "k3d-volumes"
  //     },
  //   ]
  // }
}

inputs = {
  platform_specific_vault_config = ""
  vault_namespace                = "vault"

  // created by after_hook of k3d-cluster module
  cluster_ca_crt_b64 = base64encode(file(join("/", [
    local.artifacts_abspath,
    "cluster-ca/cluster-ca.crt"
  ])))

  // get rid of this if ingress is not required
  ingress_sg = "<NOT REQUIRED IN K3D>"
}

terraform {
  after_hook "vault_unsealer" {
    commands = ["apply"]
    execute = [
      "scripts/vault-unseal.sh",
      local.vault_artifacts_abspath
    ]
  }
}
