locals {
  private_userpass_rel_paths = fileset(
    var.secrets_abspath,
    "/vault/userpasses/*.userpass.json"
  )
  userpass_records = {
    for rel_path in local.private_userpass_rel_paths : rel_path => {
      "rel_path" = rel_path,
      "name"     = trimsuffix(basename(rel_path), ".userpass.json")
      "content"  = file("${var.secrets_abspath}/${rel_path}")
    }
  }
}
