terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    telmate = {
      source = "TheGameProfi/proxmox"
    }
    bpg = {
      source = "bpg/proxmox"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}

provider "telmate" {

  pm_api_url  = "https://pve-01.lan.pezlab.dev:8006/api2/json"
  pm_user     = "root@pam"
  pm_password = data.vault_generic_secret.shared.data["root_password"]
}

provider "bpg" {

  endpoint = "https://pve-01.lan.pezlab.dev:8006/"
  username = "root@pam"
  password = data.vault_generic_secret.shared.data["root_password"]
  insecure = true

}

