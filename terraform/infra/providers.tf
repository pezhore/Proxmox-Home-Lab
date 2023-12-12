terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
    }
    proxmox = {
      source = "bpg/proxmox"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

provider "proxmox" {

  endpoint = "https://10.0.0.212:8006/"
  username = "root@pam"
  password = data.vault_generic_secret.shared.data["root_password"]
  insecure = true

}
