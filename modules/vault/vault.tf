resource "helm_release" "vault" {
  count           = local.deployment_configs.vault.count
  name            = var.vault_resource_name
  repository      = var.vault_resource_repository
  chart           = var.vault_resource_chart
  version         = var.vault_resource_version
  namespace       = kubernetes_namespace.this.metadata[0].name
  cleanup_on_fail = true
  lint            = true
  atomic          = var.helm_atomic
  timeout         = var.helm_timeout_unit

  values = [
    yamlencode({
      global = {
        enabled    = true
        tlsDisable = false
        # serverTelemetry = {
        #   prometheusOperator = true
        # }
      }
      server = {
        dataStorage = {
          enabled = true
        }
        auditStorage = {
          enabled = true
        }
        nodeSelector = {
          vault_in_k8s = "true"
        }
        ingress = {
          enabled = true
          annotations = {
            "kubernetes.io/ingress.class" = "public",
            # "kubernetes.io/tls-acme"      = "true",

            # "kubernetes.io/ingress.allow-http" : "false"
            # "nginx.ingress.kubernetes.io/force-ssl-redirect" : "true"
            # "nginx.ingress.kubernetes.io/ssl-passthrough" : "true"
            # "nginx.ingress.kubernetes.io/backend-protocol" : "HTTPS"
            # "nginx.ingress.kubernetes.io/whitelist-source-range" : "127.0.0.1"
          }
          activeService = true
          hosts = [
            {
              host = "${var.vault_subdomain}.${var.sld}.${var.tld}"
              paths = [
                "/"
              ]
            }
          ]
          tls = [
            {
              secretName = "vault-api-tls-cert"
              host       = "${var.vault_subdomain}.${var.sld}.${var.tld}"
              # paths = [
              #   "/*"
              # ]
            }
          ]
        }
        volumes = [
          {
            name = "vault-raft-tls-cert"
            secret = {
              secretName = kubernetes_secret.vault_raft_tls_cert[0].metadata[0].name
              optional   = false
            }
          },
          {
            name = "vault-api-tls-cert"
            secret = {
              secretName = kubernetes_secret.vault_api_tls_cert[0].metadata[0].name
              optional   = false
            }
          }
        ]
        volumeMounts = [
          {
            name      = "vault-raft-tls-cert"
            mountPath = "/vault/ssl/raft"
            readOnly  = true
          },
          {
            name      = "vault-api-tls-cert"
            mountPath = "/vault/ssl/api"
            readOnly  = true
          }
        ]
        extraEnvironmentVars = {
          VAULT_ADDR     = "https://127.0.0.1:8200"
          VAULT_API_ADDR = "https://$(POD_IP):8200"
          VAULT_CACERT   = "/vault/ssl/api/ca.crt"
        }
        affinity = {
          podAntiAffinity = {
            requiredDuringSchedulingIgnoredDuringExecution = [
              {
                labelSelector = {
                  matchLabels = {
                    "app.kubernetes.io/name"     = "vault"
                    "app.kubernetes.io/instance" = "vault"
                    "component"                  = "server"
                  }
                }
                topologyKey = "kubernetes.io/hostname"
              },
              {
                labelSelector = {
                  matchLabels = {
                    "app.kubernetes.io/name"     = "vault"
                    "app.kubernetes.io/instance" = "vault"
                    "component"                  = "server"
                  }
                }
                topologyKey = "topology.kubernetes.io/zone"
              }
            ]
          }
        }

        ha = {
          enabled  = true
          replicas = 3
          raft = {
            enabled   = true
            setNodeId = true
            config = templatefile("${var.assets_path}/vault/vault.ha.config.tftpl.hcl", {
              sld = var.sld
              tld = var.tld
              # leader_ca_cert_file     = "/vault/ssl/api/ca.crt"
              leader_client_cert_file = "/vault/ssl/raft/tls.crt"
              leader_client_key_file  = "/vault/ssl/raft/tls.key"
              vault_subdomain         = var.vault_subdomain
              tls_client_ca_file      = "/vault/ssl/api/ca.crt"
              tls_cert_file           = "/vault/ssl/api/tls.crt"
              tls_key_file            = "/vault/ssl/api/tls.key"
            })
          }
        }
      }

      injector = {
        enabled = true
        agentDefaults = {
          metrics = {
            enabled = true
          }
        }
      }

      ui = {
        enabled         = true
        serviceType     = "LoadBalancer"
        serviceNodePort = null
        externalPort    = 8200
      }
    })
  ]
}
