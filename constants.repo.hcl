locals {
  module_hierarchy = [
    "repo",
    "platform",
    "environment",
    "region",
    "target",
    "module"
  ]

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
