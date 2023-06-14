resource "kubernetes_storage_class" "vault_scs" {
  for_each = local.deployment_configs.vault_scs.for_each

  metadata {
    name = each.key
  }
  storage_provisioner = helm_release.host_volumes_provisioner[0].name
  reclaim_policy      = "Delete"
  parameters = {
    nodePath = var.nodes_volumes_root
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

  allowed_topologies {
    match_label_expressions {
      key = "vault_in_k8s"
      values = [
        "true"
      ]
    }
  }
}
