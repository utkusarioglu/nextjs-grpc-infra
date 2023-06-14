path "pki*" {
  capabilities = ["read", "list"]
}

path "pki/sign/services" {
  capabilities = ["create", "update"]
}

path "pki/issue/services" {
  capabilities = ["create"]
}

path "auth/kubernetes/login" {
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}
