locals {
  ingress_class_mapping = {
    "aws"   = "alb"
    "local" = "public"
  }

  ingress_paths = {
    api = {
      aws   = "/*"
      local = "/"
    }
  }

  ingress_service_types = {
    aws   = "NodePort"
    local = "ClusterIP"
  }
}
