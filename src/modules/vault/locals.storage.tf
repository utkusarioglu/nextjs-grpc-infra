locals {
  # private_storage_common_annotations = {}

  # private_storage_platform_annotations = {
  #   k3d = {
  #     nodePath = var.nodes_volumes_root
  #   }
  #   aws = {}
  # }

  # storage = {
  #   annotations = merge(
  #     local.private_storage_common_annotations,
  #     local.private_storage_platform_annotations[var.platform]
  #   )
  # }
}
