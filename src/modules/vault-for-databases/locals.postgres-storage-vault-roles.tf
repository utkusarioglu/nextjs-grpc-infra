locals {
  postgres_storage_vault_roles = {
    inflation = toset([
      "ms",
      "notebooks-basic-readonly",
      "notebooks-restricted-readonly",
      "grafana"
    ])
    ai_education_public = toset([
      "notebooks-basic-readonly"
    ])
    ai_education_restricted = toset([
      "notebooks-restricted-readonly"
    ])
  }

}
