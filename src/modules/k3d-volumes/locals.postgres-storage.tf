locals {
  postgres_storage = {
    tablespaces = {
      sc_name = "postgres-tablespaces-sc"
    }
    node_affinity = {
      key   = "postgres-storage.ms/dumps-mounted"
      value = "true"
    }
  }
}
