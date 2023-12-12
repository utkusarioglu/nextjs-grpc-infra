locals {
  module_hierarchy = [
    "repo",
    "platform",
    "environment",
    "region",
    "target",
    "module"
  ]

  module_filenames = {
    "repo"        = "terragrunt.repo.hcl"
    "platform"    = "terragrunt.platform.hcl"
    "environment" = "terragrunt.environment.hcl"
    "region"      = "terragrunt.region.hcl"
    "target"      = "terragrunt.hcl"
    "module"      = "terragrunt.module.hcl"
  }

  template_types = [
    "required_providers",
    "providers",
    "backends",
    "data",
    "locals",
    "vars"
  ]

  targets_path = "src/targets"
  modules_path = "src/modules"
}
