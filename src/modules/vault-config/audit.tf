resource "vault_audit" "file" {
  type = "file"

  options = {
    // TODO connect this to loki
    // This where audit storage is mounted to
    file_path = "/vault/audit/audit.log"
  }
}
