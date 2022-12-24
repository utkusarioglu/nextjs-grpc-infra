resource "kubernetes_persistent_volume_claim" "ethereum_pvc" {
  count = local.deployment_configs.ethereum_pvc.count
  metadata {
    name      = "ethereum-pvc"
    namespace = "ms"
  }
  spec {
    # local-path provisioner comes with k3d
    storage_class_name = "local-path"

    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = "ethereum-pv"
  }
  wait_until_bound = true
}

resource "helm_release" "ethereum_storage" {
  count             = local.deployment_configs.ethereum_storage.count
  name              = "ethereum-storage"
  repository        = "https://charts.bitnami.com/bitnami"
  chart             = "postgresql"
  version           = "11.9.8"
  namespace         = "ms"
  dependency_update = true
  timeout           = var.helm_timeout_unit
  atomic            = var.helm_atomic

  values = [
    yamlencode({
      global = {
        postgresql = {
          auth = {
            postgresPassword = "postgres"
            username         = "test"
            password         = "test"
            database         = "test"
          }
        }
      }
      primary = {
        persistence = {
          enabled       = true
          existingClaim = "ethereum-pvc"
          size          = "1Gi"
        }
        resources = {
          requests = {
            memory = 0
            cpu    = 0
          }
        }
      }
      metrics = {
        enabled = true
      }
    })
  ]
}
