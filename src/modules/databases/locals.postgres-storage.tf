locals {
  private_postgres_storage_common_annotations = {}
  private_postgres_storage_platform_annotations = {
    k3d = {
      "volume.kubernetes.io/selected-node" = "worker-2"
    }
    aws = {
      # "volume.kubernetes.io/selected-node" = "ip-10-0-38-110.eu-central-1.compute.internal"
    }
  }

  postgres_storage = {
    namespace        = "ms"
    default_database = "postgres"
    tablespaces = {
      pvc_name     = "postgres-tablespaces-pvc"
      sc_name      = "postgres-tablespaces-sc"
      access_mode  = "ReadWriteOnce"
      storage_size = "10Gi"
    }
    node_affinity = {
      key   = "postgres-storage.ms/dumps-mounted"
      value = "true"
    }

    annotations = merge(
      local.private_postgres_storage_common_annotations,
      local.private_postgres_storage_platform_annotations[var.platform],
    )
  }
}
