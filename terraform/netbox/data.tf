##################################################
# data.tf
#
# This file contains the data sources for the Terraform configuration.

data "vault_generic_secret" "netbox" {
  path = "homelab/software/netbox"
}

data "vault_generic_secret" "shared" {
  path = "homelab/shared"
}

data "netbox_cluster_type" "proxmox" {
  name = "Proxmox"
}
