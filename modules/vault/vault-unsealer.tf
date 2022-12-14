resource "null_resource" "vault_unsealer" {
  provisioner "local-exec" {
    command    = "scripts/vault-unseal.sh"
    on_failure = fail
    when       = create
  }
  depends_on = [
    helm_release.vault[0]
  ]
}
