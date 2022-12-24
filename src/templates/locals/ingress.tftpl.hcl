locals {
  ingress_class_mapping = {
    aws = "alb"
    k3d = "public"
  }

  ingress_paths = {
    api = {
      aws = "/*"
      k3d = "/"
    }
  }

  ingress_service_types = {
    aws = "NodePort"
    k3d = "ClusterIP"
  }
}
