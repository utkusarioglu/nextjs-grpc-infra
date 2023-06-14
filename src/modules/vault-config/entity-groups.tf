resource "vault_identity_group" "notebooks" {
  name = "notebooks"
  type = "internal"
  metadata = {
    version = "2"
  }
  policies = [
    "postgres_storage_inflation_entity",
    "postgres_storage_ai_education_public_entity"
  ]
}

resource "vault_identity_group_member_entity_ids" "notebooks" {
  exclusive = true
  group_id  = vault_identity_group.notebooks.id
  member_entity_ids = [
    for entity in vault_identity_entity.userpass :
    entity.id if startswith(entity.name, "notebooks")
  ]
}
