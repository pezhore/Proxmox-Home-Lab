storage "raft" {
    path = "/vault/raft/data"
    node_id = "vault-01"
    retry_join 
    {
        leader_api_addr = "http://vault-02.lan.pezlab.dev:8200"
        // leader_ca_cert_file = "/etc/vault.d/ssl/tls_ca.pem"
        // leader_client_cert_file = "/etc/vault.d/ssl/tls.crt"
        // leader_client_key_file = "/etc/vault.d/ssl/tls.key"
    }
    retry_join 
    {
        leader_api_addr = "http://vault-03.lan.pezlab.dev:8200"
        // leader_ca_cert_file = "/etc/vault.d/ssl/tls_ca.pem"
        // leader_client_cert_file = "/etc/vault.d/ssl/tls.crt"
        // leader_client_key_file = "/etc/vault.d/ssl/tls.key"
    }
    retry_join 
    {
        leader_api_addr = "http://vault-04.lan.pezlab.dev:8200"
        // leader_ca_cert_file = "/etc/vault.d/ssl/tls_ca.pem"
        // leader_client_cert_file = "/etc/vault.d/ssl/tls.crt"
        // leader_client_key_file = "/etc/vault.d/ssl/tls.key"
    }
}

listener "tcp" {
   address = "0.0.0.0:8200"
   tls_disable = true
//    tls_cert_file = "/etc/vault.d/ssl/tls.crt"
//    tls_key_file = "/etc/vault.d/ssl/tls.key"
//    tls_client_ca_file = "/etc/vault.d/ssl/tls_ca.pem"
}
api_addr = "http://vault-01.lan.pezlab.dev:8200"
cluster_addr = "http://vault-01.lan.pezlab.dev:8201"
disable_mlock = true
ui = true
log_level = "trace"
disable_cache = true
cluster_name = "POC"