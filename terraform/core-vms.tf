#################################################
# core-vms.tf
#
# This file contains the resources to create the core VMs in the lab.
# It is driven by the ""single manifest"", ./external/config.yml and will
# automatically provision/deprovision VMs based on the contents of that file.

resource "proxmox_vm_qemu" "core_vms" {
  for_each    = local.config.core_vms
  name        = each.key
  target_node = local.config.lab.node
  # another variable with contents "ubuntu-2004-cloudinit-template"
  clone = each.value.template
  # basic VM settings here. agent refers to guest agent
  agent   = 1
  os_type = "cloud-init"
  cores   = each.value.cores
  sockets = each.value.sockets
  cpu     = "host"
  memory  = each.value.memory
  scsihw  = "virtio-scsi-pci"

  disk {
    slot = 0
    # set disk size here. leave it small for testing because expanding the disk takes time.
    size     = each.value.disk_size
    type     = "scsi"
    storage  = local.config.lab.storage
    format   = "qcow2"
  }

  # if you want two NICs, just copy this whole network section and duplicate it
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  # not sure exactly what this is for. presumably something about MAC addresses and ignore network changes during the life of the VM
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # the ${count.index + 1} thing appends text to the end of the ip address
  # in this case, since we are only adding a single VM, the IP will
  # be 10.98.1.91 since count.index starts at 0. this is how you can create
  # multiple VMs and have an IP assigned to each (.91, .92, .93, etc.)
  ipconfig0 = "ip=${each.value.ipaddr},gw=${each.value.gateway}"

  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = <<EOF
  ${local.config.lab.sshkey}
  EOF
}