resource "kubernetes_persistent_volume" "ethereum_pv" {
  count = local.deployment_configs.ethereum_pv.count

  metadata {
    name = "ethereum-pv"
  }

  spec {
    storage_class_name = "local-path" # This is created by Rancher in K3d
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      local {
        path = "${var.persistent_volumes_root}/ethereum-pv"
      }
    }
    persistent_volume_reclaim_policy = "Delete"
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values = [
              "worker-3",
              "worker-4"
            ]
          }
        }
      }
    }
  }
}
