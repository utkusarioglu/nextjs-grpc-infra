resource "helm_release" "host_volumes_provisioner" {
  count           = 1
  name            = var.host_volumes_provisioner_resource_name
  repository      = var.host_volumes_provisioner_resource_repository
  chart           = var.host_volumes_provisioner_resource_chart
  version         = var.host_volumes_provisioner_resource_version
  namespace       = "kube-system"
  cleanup_on_fail = true
  lint            = true
  atomic          = var.helm_atomic
  timeout         = var.helm_timeout_unit

  set {
    name  = "storageClass.create"
    value = false
  }

  set {
    name = "storageClass.provisionerName"
    # Storage classes require on the variable below.
    # But they inherit it from the `name` of this resource.
    # So, changing this without changing the `name` attribute 
    # will break storage classes.
    value = var.host_volumes_provisioner_resource_name
  }

  set {
    name  = "configMap.name"
    value = "host-volumes-provisioner-config"
  }

  set {
    name  = "nodePathMap[0].node"
    value = "DEFAULT_PATH_FOR_NON_LISTED_NODES"
  }

  set {
    name  = "nodePathMap[0].paths"
    value = "{${var.nodes_volumes_root},${var.nodes_source_code_root}}"
  }
}
