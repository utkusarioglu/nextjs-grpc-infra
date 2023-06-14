resource "kubernetes_persistent_volume_claim_v1" "postgres_tablespaces_pvc" {
  count = local.deployment_configs.postgres_tablespaces_pvc.count
  metadata {
    name        = local.postgres_storage.tablespaces.pvc_name
    namespace   = local.postgres_storage.namespace
    annotations = local.postgres_storage.annotations
  }
  spec {
    storage_class_name = local.postgres_storage.tablespaces.sc_name
    access_modes = [
      local.postgres_storage.tablespaces.access_mode
    ]
    resources {
      requests = {
        storage = local.postgres_storage.tablespaces.storage_size
      }
    }
  }
}
