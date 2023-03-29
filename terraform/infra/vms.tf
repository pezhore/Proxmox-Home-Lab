resource "proxmox_virtual_environment_vm" "ubuntu_jammy" {
  for_each = toset(local.config.lab.nodes)
  agent {
    enabled = true
  }

  description = "Managed by Terraform"

  disk {
    datastore_id = local.vm_ds
    file_id      = proxmox_virtual_environment_file.ubuntu["jammy"].id
    interface    = "scsi0"
    discard      = "on"
    ssd          = true
  }

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

  name = "${each.key}-jammy-template"

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
      ipv4_addresses,
      ipv6_addresses,
      network_interface_names,
    ]
  }
}