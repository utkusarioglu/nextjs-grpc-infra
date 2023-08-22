resource "helm_release" "postgres_storage" {
  count             = local.deployment_configs.postgres_storage.count
  name              = var.postgres_storage_resource_name
  repository        = var.postgres_storage_resource_repository
  chart             = var.postgres_storage_resource_chart
  version           = var.postgres_storage_resource_version
  namespace         = local.postgres_storage.namespace
  dependency_update = true
  timeout           = var.helm_timeout_unit
  atomic            = var.helm_atomic

  values = [
    yamlencode({
      fullnameOverride = var.postgres_storage_resource_name
      global = {
        postgresql = {
          auth = {
            postgresPassword = local.postgres_storage_master_credentials.password
            database         = local.postgres_storage.default_database
          }
        }
      }
      primary = {
        nodeSelector = {
          (local.postgres_storage.node_affinity.key) = local.postgres_storage.node_affinity.value
        }
        persistence = {
          enabled       = true
          existingClaim = local.postgres_storage.tablespaces.pvc_name
          mountPath     = "/tablespaces"
          size          = local.postgres_storage.tablespaces.storage_size
        }
        resources = {
          requests = {
            memory = 0
            cpu    = 0
          }
        }
        initContainers = [
          {
            name  = "prepare-required-paths"
            image = "busybox:latest"
            securityContext = {
              privileged = true
            }
            command = [
              "sh",
              "-c"
            ]
            args = [
              <<-EOF
                chown -R 1001:0 /dumps
                echo "/dumps path:"
                ls -al /dumps

                mkdir -p /tablespaces/happiness
                mkdir -p /tablespaces/inflation
                mkdir -p /tablespaces/ai-education
                chown -R 1001:0 /tablespaces
                echo "/tablespaces path:"
                ls -al /tablespaces

                # ensures that the folder is available and accessible
                ls_exit_code=$?
                exit $ls_exit_code
              EOF
            ]
            volumeMounts = [
              {
                # This is created by `primary.persistence` section
                name      = "data"
                mountPath = "/tablespaces"
              },
            ]
          }
        ]
        extraVolumeMounts = [
          {
            name      = "postgres-storage-migrations-sql-tar"
            mountPath = "/postgres-storage-migrations-sql-tar"
          },
          {
            name      = "postgres-storage-migrations-data-tar"
            mountPath = "/postgres-storage-migrations-data-tar"
          },
          {
            name      = "migrations",
            mountPath = "/migrations"
          }
        ]
        extraVolumes = [
          {
            name = "postgres-storage-migrations-sql-tar"
            configMap = {
              name = kubernetes_config_map.postgres_storage_migrations_sql[0].metadata[0].name
            }
          },
          {
            name = "postgres-storage-migrations-data-tar"
            configMap = {
              name = kubernetes_config_map.postgres_storage_migrations_data[0].metadata[0].name
            }
          },
          {
            name = "migrations",
            emptyDir = {
              sizeLimit = "100Mi"
            }
          }
        ]
        initdb = {
          scripts = {
            "run-migrations.sh" = templatefile(
              "templates/postgres-storage-init-script.tftpl.sh",
              {
                postgres_username                   = local.postgres_storage_master_credentials.username
                postgres_password                   = local.postgres_storage_master_credentials.password
                default_database                    = local.postgres_storage.default_database
                vault_manager_group_name            = "g_vault_managed"
                vault_manager_ai_education_username = local.postgres_storage_vault_manager_ai_education_role_credentials.username
                vault_manager_ai_education_password = local.postgres_storage_vault_manager_ai_education_role_credentials.password
                vault_manager_inflation_username    = local.postgres_storage_vault_manager_inflation_role_credentials.username
                vault_manager_inflation_password    = local.postgres_storage_vault_manager_inflation_role_credentials.password
              }
            )
          }
        }
      }
      metrics = {
        enabled = true
      }
    })
  ]
}
