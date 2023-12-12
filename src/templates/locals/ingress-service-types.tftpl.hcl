locals {
  ingress_service_types = {
    aws = "NodePort"
    k3d = "ClusterIP"
  }
}
