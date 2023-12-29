terraform {
  required_providers {
    freeipa = {
      source  = "rework-space-com/freeipa"
      version = "4.0.0"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "4.3.1"
    }
  }
}

provider "freeipa" {
  host     = "ldap.lan.pezlab.dev"
  username = "admin"
  password = data.vault_generic_secret.freeipa.data["ipaadmin_password"]
}

provider "keycloak" {
  client_id                = "admin-cli"
  username                 = "user"
  password                 = data.vault_generic_secret.keycloak.data["admin_password"]
  url                      = "https://keycloak.lan.pezlab.dev"
  realm                    = "master"
  tls_insecure_skip_verify = true
}