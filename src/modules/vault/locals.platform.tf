locals {
  platform_signer_name = {
    aws = "beta.eks.amazonaws.com/app-serving"
    k3d = "kubernetes.io/kubelet-serving"
  }
}
