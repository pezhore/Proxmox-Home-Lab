terraform {
  required_providers {
    powerdns = {
      source = "pan-net/powerdns"
    }
  }
}

provider "powerdns" {
  api_key        = data.vault_generic_secret.pdns.data["terraform_key"]
  server_url     = "https://powerdns.lan.pezlab.dev"
  insecure_https = true
}