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
 pm_log_enable = true
  pm_log_file = "terraform-plugin-proxmox.log"
  pm_debug = true
  pm_log_levels = {
    _default = "debug"
    _capturelog = ""
 }
}

provider "bpg" {

  endpoint = "https://pve-01.lan.pezlab.dev:8006/"
  username = "root@pam"
  password = data.vault_generic_secret.shared.data["root_password"]
  insecure = true

}

