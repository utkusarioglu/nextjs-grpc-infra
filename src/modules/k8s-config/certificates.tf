resource "helm_release" "certificates" {
  count = local.deployment_configs.certificates.count

  name              = "certificates"
  chart             = "${var.project_root_abspath}/certificates"
  dependency_update = true
  timeout           = var.helm_timeout_unit
  atomic            = var.helm_atomic

  set {
    name  = "vaultIssuerRef.secretName"
    value = kubernetes_secret_v1.services_issuer["api"].metadata[0].name
  }

  set {
    name  = "vaultIssuerRef.mountPath"
    value = var.vault_kubernetes_mount_path
  }

  set {
    name  = "vaultIssuerRef.caBundle"
    value = base64encode(local.certs.vault.bundle)
  }

  # depends_on = [
  #   helm_release.cert_manager[0]
  # ]
}
