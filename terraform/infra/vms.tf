resource "proxmox_virtual_environment_vm" "ubuntu_jammy" {
  for_each = toset(local.config.lab.nodes)
  agent {
    enabled = true
  }

  description = "Managed by Terraform"

  #  disk {
  #    datastore_id = local.vm_ds
  #    file_id      = proxmox_virtual_environment_file.ubuntu["jammy"].id
  #    interface    = "virtio0"
  #    iothread     = true
  #  }

  disk {
    datastore_id = local.vm_ds
    file_id      = proxmox_virtual_environment_file.ubuntu["jammy"].id
    interface    = "scsi0"
    discard      = "on"
    ssd          = true
  }
  #
  #  disk {
  #    datastore_id = "nfs"
  #    interface    = "scsi1"
  #    discard      = "ignore"
  #    file_format  = "raw"
  #  }

  initialization {
    datastore_id = local.vm_ds

    dns {
      server = "1.1.1.1"
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    vendor_data_file_id = proxmox_virtual_environment_file.vendor_config.id
  }

  name = "jammy-template"

  node_name = each.key

  operating_system {
    type = "l26"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  pool_id = proxmox_virtual_environment_pool.lab.id

  serial_device {}

  template = true
  vm_id    = (2050 + index(local.config.lab.nodes, each.value))


  lifecycle {
    ignore_changes = [
      initialization,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "core" {
  for_each  = local.config.core_vms
  name      = each.key
  node_name = each.value.node
  pool_id   = proxmox_virtual_environment_pool.lab.id
  vm_id     = each.value.vm_id
  tags      = ["terraform", "ubuntu"]

  clone {
    vm_id = proxmox_virtual_environment_vm.ubuntu_jammy[each.value.node].id
  }

  memory {
    dedicated = each.value.memory
  }

  # connection {
  #   type        = "ssh"
  #   agent       = false
  #   host        = element(element(self.ipv4_addresses, index(self.network_interface_names, "eth0")), 0)
  #   private_key = data.vault_generic_secret.terraform.data["pm_private_key"]
  #   user        = "ubuntu"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "echo Welcome to $(hostname)!",
  #   ]
  # }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    user_data_file_id   = proxmox_virtual_environment_file.user_config[each.key].id
    vendor_data_file_id = proxmox_virtual_environment_file.vendor_config.id

    dns {
      server = local.config.lab.dns[0]
    }
    ip_config {
      ipv4 {
        address = each.value.ipv4
        gateway = each.value.gateway
      }
    }
  }

  lifecycle {
    ignore_changes = [
      ipv4_addresses,
      ipv6_addresses,
      network_interface_names,
      initialization,
      clone,
    ]
  }

}