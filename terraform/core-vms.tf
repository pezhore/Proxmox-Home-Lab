#################################################
# core-vms.tf
#
# This file contains the resources to create the core VMs in the lab.
# It is driven by the ""single manifest"", ./external/config.yml and will
# automatically provision/deprovision VMs based on the contents of that file.

resource "proxmox_vm_qemu" "core_vms" {

  # Iterate over our yaml config with each core_vm has its own config
  for_each    = local.config.core_vms
  name        = each.key
  desc        = each.value.description

  target_node = local.config.lab.node
  clone = each.value.template

  # When set to 1, the QEMU Guest Agent is enabled. This does require
  # installing/running the qemu-guest-agent service inside the VM
  agent   = 1
  os_type = each.value.os_type
  cores   = each.value.cores
  sockets = each.value.sockets
  cpu     = "host"              # Set the type of CPU to whatever our proxmox host has
  memory  = each.value.memory
  scsihw  = each.value.scsihw

  # Iterate over our disks and create a block for each one
  # This allows for multiple disks to be specified in our config without having
  # to edit our terraform code
  dynamic "disk" {
    iterator = disk
    for_each = each.value.dynamic.disks

    content {
      size    = disk.value.size
      type    = disk.value.type
      storage = disk.value.storage
      format  = disk.value.format
    }
  }

  # Iterate over our networks and create a block for each one
  # This allows for multiple network configs to be specified in our config without having
  # to edit our terraform code
  dynamic "network" {
    iterator = nic
    for_each = each.value.dynamic.networks
    content {
      model  = nic.value.model
      bridge = nic.value.bridge
    }
  }

  # I'm not sure if this is needed, possibly because the default behavior if a
  # network change occurs is to reprovision the system?
  lifecycle {
    ignore_changes = [
      network,
    ]
  }


  # Annoyingly, there doesn't appear to be a way to dynamically create more
  # default IP addresses for each network interface - so we crete the first one,
  # then use Ansible to configure/set the rest.
  ipconfig0 = "ip=${each.value.ipaddr},gw=${each.value.gateway}"

  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = <<EOF
  ${data.http.github_ssh_keys.response_body}
  EOF
}