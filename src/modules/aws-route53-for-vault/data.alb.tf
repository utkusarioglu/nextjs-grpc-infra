data "kubernetes_service" "vault_lb" {
  metadata {
    name      = "vault-ui"
    namespace = "vault"
  }
}
data "aws_elb" "vault_lb" {
  # name = "a41b1549995e2454ea269ca7232346dd"
  # name = "a4b9d01b9d25a47c086ff509541f11db"
  # name = "nextjs-grpc-vault"
  # name = split("-", "a00616615255446a5a50bd4d43c14f60-1425958717.eu-central-1.elb.amazonaws.com").0
  name = split("-", data.kubernetes_service.vault_lb.status.0.load_balancer.0.ingress.0.hostname).0
  # tags = {
  #   "kubernetes.io/service-name" = "vault/vault-ui"
  #   # "kubernetes.io/cluster/ng-aws-dev-euc1" = "owned"
  # }
}
