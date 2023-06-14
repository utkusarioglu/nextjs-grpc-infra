ui           = true
api_addr     = "https://${vault_subdomain}.${sld}.${tld}"
cluster_addr = "https://vault-0.vault-internal:8201"

listener "tcp" {
  address            = "[::]:8200"
  cluster_address    = "[::]:8201"
  tls_client_ca_file = "${tls_client_ca_file}"
  tls_cert_file      = "${tls_cert_file}"
  tls_key_file       = "${tls_key_file}"
  tls_min_version    = "tls12"
}

storage "raft" {
  path      = "/vault/data"
  setNodeId = true

  retry_join {
    // leader_tls_servername   = "vault"
    leader_api_addr         = "https://vault-0.vault-internal:8200"
    leader_ca_cert_file     = "${tls_client_ca_file}"
    leader_client_cert_file = "${leader_client_cert_file}"
    leader_client_key_file  = "${leader_client_key_file}"
  }

  retry_join {
    // leader_tls_servername   = "vault"
    leader_api_addr         = "https://vault-1.vault-internal:8200"
    leader_ca_cert_file     = "${tls_client_ca_file}"
    leader_client_cert_file = "${leader_client_cert_file}"
    leader_client_key_file  = "${leader_client_key_file}"
  }

  retry_join {
    // leader_tls_servername   = "vault"
    leader_api_addr         = "https://vault-2.vault-internal:8200"
    leader_ca_cert_file     = "${tls_client_ca_file}"
    leader_client_cert_file = "${leader_client_cert_file}"
    leader_client_key_file  = "${leader_client_key_file}"
  }

  autopilot {
    cleanup_dead_servers           = "true"
    last_contact_threshold         = "200ms"
    last_contact_failure_threshold = "10m"
    max_trailing_logs              = 250000
    min_quorum                     = 3
    server_stabilization_time      = "10s"
  }
}

service_registration "kubernetes" {}
