##################################################
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

##############
# Proxmox things
data "proxmox_virtual_environment_nodes" "lab" {
  provider = bpg
}

data "proxmox_virtual_environment_datastores" "lab" {
  provider = bpg
  # for_each = data.proxmox_virtual_environment_nodes.lab.names
  # node_name = each.key

  node_name = data.proxmox_virtual_environment_nodes.lab.names[1]
}