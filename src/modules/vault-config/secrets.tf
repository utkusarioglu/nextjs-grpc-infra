resource "null_resource" "postgres_storage_postgres_role" {
  provisioner "local-exec" {
    command = templatefile("templates/vault-scripts.tftpl.sh", {
      role_path = join("/", [
        vault_mount.secrets[0].path,
        "postgres-storage",
        "static-roles",
        "postgres"
      ])
      username_prefix            = "postgres"
      password_prefix            = "postgres_master"
      username_randomizer_length = 0
      password_randomizer_length = 30
    })
  }
}


resource "null_resource" "postgres_storage_inflation_role" {
  provisioner "local-exec" {
    command = templatefile("templates/vault-scripts.tftpl.sh", {
      role_path = join("/", [
        vault_mount.secrets[0].path,
        "postgres-storage",
        "static-roles",
        "vault-manager-inflation"
      ])
      username_prefix            = "inflation"
      password_prefix            = "inflation"
      username_randomizer_length = 4
      password_randomizer_length = 30
    })
  }
}

resource "null_resource" "postgres_storage_ai_education_role" {
  provisioner "local-exec" {
    command = templatefile("templates/vault-scripts.tftpl.sh", {
      role_path = join("/", [
        vault_mount.secrets[0].path,
        "postgres-storage",
        "static-roles",
        "vault-manager-ai-education"
      ])
      username_prefix            = "ai_education"
      password_prefix            = "ai_education"
      username_randomizer_length = 4
      password_randomizer_length = 30
    })
  }
}
