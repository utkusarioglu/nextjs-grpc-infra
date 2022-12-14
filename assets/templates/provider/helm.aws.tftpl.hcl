// provider "helm" {
//   kubernetes {
//     config_path    = "~/.kube/config"
//     config_context = "k3d-${cluster_name}"
//   }
//   experiments {
//     manifest = true
//   }
// }

provider "helm" {
  kubernetes {
    host                   = module.aws.cluster_endpoint
    cluster_ca_certificate = module.aws.cluster_ca_certificate
    token                  = module.aws.cluster_token
  }
}
