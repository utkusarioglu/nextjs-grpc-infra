resource "helm_release" "vault" {
  count      = local.deployment_configs.vault.count
  name       = var.vault_resource_name
  repository = var.vault_resource_repository
  chart      = var.vault_resource_chart
  version    = var.vault_resource_version
  # namespace       = kubernetes_namespace.this.metadata[0].name
  namespace       = var.vault_namespace
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
          enabled      = true
          storageClass = "vault-data-sc"
          # annotations  = local.storage.annotations
        }
        auditStorage = {
          enabled      = true
          storageClass = "vault-audit-sc"
          # annotations  = local.storage.annotations
        }
        nodeSelector = {
          vault_in_k8s = "true"
        }
        extraArgs = "-log-level=trace"
        ingress = {
          enabled       = true
          annotations   = local.ingress.annotations
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
          VAULT_ADDR           = "https://127.0.0.1:8200"
          VAULT_API_ADDR       = "https://$(POD_IP):8200"
          VAULT_CACERT         = "/vault/ssl/api/ca.crt"
          VAULT_CLIENT_TIMEOUT = "300s"
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
            config = join("\n", [templatefile("${var.configs_abspath}/vault/vault.ha.config.tftpl.hcl", {
              sld = var.sld
              tld = var.tld
              # leader_ca_cert_file     = "/vault/ssl/api/ca.crt"
              leader_client_cert_file = "/vault/ssl/raft/tls.crt"
              leader_client_key_file  = "/vault/ssl/raft/tls.key"
              vault_subdomain         = var.vault_subdomain
              tls_client_ca_file      = "/vault/ssl/api/ca.crt"
              tls_cert_file           = "/vault/ssl/api/tls.crt"
              tls_key_file            = "/vault/ssl/api/tls.key"
              }),
              var.platform_specific_vault_config
            ])
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
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-name" = "nextjs-grpc-vault"
          #   # "kubernetes.io/ingress.class"            = local.ingress_class_mapping[var.platform]
          #   "kubernetes.io/ingress.class"            = "nlb"
          #   "alb.ingress.kubernetes.io/scheme"       = "internet-facing"
          #   "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTPS\":8200}]"
          #   # "alb.ingress.kubernetes.io/ssl-redirect" = "8200"
          #   # "alb.ingress.kubernetes.io/target-type"        = "ip"
          #   "alb.ingress.kubernetes.io/group.name"         = "nextjs-grpc"
          #   "alb.ingress.kubernetes.io/load-balancer-name" = "nextjs-grpc-vault"
          #   "alb.ingress.kubernetes.io/security-groups"    = var.ingress_sg
        }
      }
    })
  ]
}
