locals {
  private_ingress_common_annotations = {
    "kubernetes.io/ingress.class" = local.ingress_class_mapping[var.platform]

    # "kubernetes.io/tls-acme"      = "true",
    # "kubernetes.io/ingress.allow-http" : "false"
  }

  private_ingress_platform_annotations = {
    k3d = {
      # "nginx.ingress.kubernetes.io/force-ssl-redirect" : "true"
      # "nginx.ingress.kubernetes.io/ssl-passthrough" : "true"
      # "nginx.ingress.kubernetes.io/backend-protocol" : "HTTPS"
      # "nginx.ingress.kubernetes.io/whitelist-source-range" : "127.0.0.1"
    }

    aws = {
      # "alb.ingress.kubernetes.io/scheme"       = "internet-facing"
      # "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTPS\":8200}]"
      # # "alb.ingress.kubernetes.io/ssl-redirect" = "8200"

      # "alb.ingress.kubernetes.io/target-type"        = "ip"
      # "alb.ingress.kubernetes.io/group.name"         = "nextjs-grpc"
      # "alb.ingress.kubernetes.io/load-balancer-name" = "nextjs-grpc-vault"
      # "alb.ingress.kubernetes.io/security-groups"    = var.ingress_sg

      # "alb.ingress.kubernetes.io/load-balancer-name" = "vault-alb"

      # "alb.ingress.kubernetes.io/group.order"  = "10"
      # "service.beta.kubernetes.io/aws-load-balancer-name" = "nextjs-grpc-vault"
      #  service.beta.kubernetes.io/aws-load-balancer-type: "nlb" 
    }
  }

  ingress = {

    annotations = merge(
      local.private_ingress_common_annotations,
      local.private_ingress_platform_annotations[var.platform]
    )
  }
}
