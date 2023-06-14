locals {
  ingress_class_mapping = {
    aws = "alb"
    k3d = "public"
  }

  ingress_paths = {
    // TODO remove this as soon as api microservice deprecates
    api = {
      aws = "/*"
      k3d = "/"
    }
    web_server = {
      aws = "/*"
      k3d = "/"
    }
  }

  ingress_service_types = {
    aws = "NodePort"
    k3d = "ClusterIP"
  }
}
