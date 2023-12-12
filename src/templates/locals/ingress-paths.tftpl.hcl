locals {
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
}
