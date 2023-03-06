#################################################
# data.tf
#
# This file contains the data sources for the Terraform configuration.

data "vault_generic_secret" "terraform" {
  path = "homelab/terraform"
}

data "vault_generic_secret" "proxmox" {
  path = "homelab/Proxmox"
}

data "vault_generic_secret" "shared" {
  path = "homelab/shared"
}

data "http" "github_ssh_keys" {
  url = "https://github.com/pezhore.keys"
}

##############3
# Proxmox things
data "proxmox_virtual_environment_nodes" "lab" {}

data "proxmox_virtual_environment_datastores" "lab" {
  node_name = data.proxmox_virtual_environment_nodes.lab.names[0]
}