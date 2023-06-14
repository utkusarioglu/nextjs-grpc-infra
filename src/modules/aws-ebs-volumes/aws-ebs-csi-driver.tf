resource "helm_release" "aws_ebs_csi_driver" {
  count      = 1
  namespace  = "kube-system"
  name       = var.aws_ebs_csi_driver_resource_name
  repository = var.aws_ebs_csi_driver_resource_repository
  chart      = var.aws_ebs_csi_driver_resource_chart
  version    = var.aws_ebs_csi_driver_resource_version
  atomic     = true
  timeout    = 600

  values = [
    yamlencode({
      node = {
        tolerateAllTaints = true
      }
      controller = {
        serviceAccount = {
          create = true
          name   = local.ebs_csi_driver_service_account
          annotations = {
            "eks.amazonaws.com/role-arn" = module.ebs_csi_driver_iam.iam_role_arn
          }
        }
      }
    })
  ]
}

module "ebs_csi_driver_iam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.11.2"

  role_name             = "ebs-csi-controller-sa"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = var.cluster_oidc_provider_arn
      namespace_service_accounts = ["kube-system:${local.ebs_csi_driver_service_account}"]
    }
  }
}
