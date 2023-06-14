resource "kubernetes_persistent_volume_v1" "source_code_pvs" {
  for_each = local.deployment_configs.source_code_pvs.for_each

  metadata {
    name = "source-code-${each.key}-pv"
  }
  spec {
    capacity = {
      storage = "20Gi"
    }
    access_modes       = ["ReadWriteMany"]
    storage_class_name = kubernetes_storage_class.source_code_sc.0.metadata.0.name

    persistent_volume_source {
      host_path {
        path = var.nodes_source_code_root
        type = "Directory"
      }
    }
  }
}
