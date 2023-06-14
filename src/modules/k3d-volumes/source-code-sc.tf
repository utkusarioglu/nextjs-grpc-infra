resource "kubernetes_storage_class" "source_code_sc" {
  count = 1

  metadata {
    name = "source-code-sc"
  }

  allow_volume_expansion = true
  storage_provisioner    = helm_release.host_volumes_provisioner.0.name
  reclaim_policy         = "Retain"
  parameters = {
    nodePath = var.nodes_source_code_root
  }
  volume_binding_mode = "WaitForFirstConsumer"
  mount_options = [
    "file_mode=0700",
    "dir_mode=0777",
    "mfsymlinks",
    "uid=1000",
    "gid=1000",
    "nobrl",
    "cache=none"
  ]
}
