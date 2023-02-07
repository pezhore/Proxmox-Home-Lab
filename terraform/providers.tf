#################################################
# providers.tf
#
# This file contains the provider configuration for the Terraform configuration.

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.12.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.3.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
  }
}

provider "proxmox" {
  # Configuration options
  pm_api_url  = "https://pve-01.pezlab.local:8006/api2/json"
  pm_user     = data.vault_generic_secret.terraform.data["pm_user"]
  pm_password = data.vault_generic_secret.terraform.data["pm_password"]

  #   pm_log_enable = true
  #   pm_log_file   = "terraform-plugin-proxmox.log"
  #   pm_debug      = true
  #   pm_log_levels = {
  #     _default    = "debug"
  #     _capturelog = ""
  #   }
}