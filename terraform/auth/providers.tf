terraform {
  required_providers {
    freeipa = {
      source  = "rework-space-com/freeipa"
      version = "4.0.0"
    }
  }
}

provider "freeipa" {
  host     = "ldap.lan.pezlab.dev"
  username = "admin"
  password = data.vault_generic_secret.freeipa.data["ipaadmin_password"]
}