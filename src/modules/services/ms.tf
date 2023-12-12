resource "helm_release" "ms" {
  count             = local.deployment_configs.ms.count
  name              = "ms"
  chart             = "${var.project_root_abspath}/ms/.helm"
  dependency_update = true
  namespace         = "ms"
  timeout           = var.helm_timeout_unit * 3
  atomic            = var.helm_atomic
  force_update      = true

  values = [
    yamlencode({
      image = {
        tag = var.ms_image_tag
      }
      env = {
        RUN_MODE = "production"
        # FEATURE_INSTRUMENTATION = "false"
      }
      cloudProvider = {
        isLocal = true
      }
    })
  ]
}
