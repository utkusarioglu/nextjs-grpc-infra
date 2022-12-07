data "external" "ca" {
  program = ["scripts/kubectl-get-ca.sh"]
}

data "external" "crt_bundle" {
  program = ["scripts/kubectl-get-crt-bundle.sh"]
}
