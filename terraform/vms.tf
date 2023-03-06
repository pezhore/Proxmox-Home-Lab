resource "proxmox_virtual_environment_vm" "example_template" {
  agent {
    enabled = true
  }

  description = "Managed by Terraform"

  #  disk {
  #    datastore_id = local.datastore_id
  #    file_id      = proxmox_virtual_environment_file.ubuntu["jammy"].id
  #    interface    = "virtio0"
  #    iothread     = true
  #  }

  disk {
    datastore_id = local.datastore_id
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
    datastore_id = local.datastore_id

    dns {
      server = "1.1.1.1"
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id   = proxmox_virtual_environment_file.user_config.id
    vendor_data_file_id = proxmox_virtual_environment_file.vendor_config.id
  }

  name = "terraform-provider-proxmox-example-template"

  node_name = data.proxmox_virtual_environment_nodes.lab.names[0]

  operating_system {
    type = "l26"
  }

  pool_id = proxmox_virtual_environment_pool.lab.id

  serial_device {}

  template = true
  vm_id    = 2040
}

resource "proxmox_virtual_environment_vm" "example" {
  name      = "terraform-provider-proxmox-example"
  node_name = data.proxmox_virtual_environment_nodes.lab.names[0]
  pool_id   = proxmox_virtual_environment_pool.lab.id
  vm_id     = 2041
  tags      = ["terraform", "ubuntu"]

  clone {
    vm_id = proxmox_virtual_environment_vm.example_template.id
  }

  memory {
    dedicated = 768
  }

  connection {
    type        = "ssh"
    agent       = false
    host        = element(element(self.ipv4_addresses, index(self.network_interface_names, "eth0")), 0)
    private_key = data.vault_generic_secret.terraform.data["pm_private_key"]
    user        = "ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "echo Welcome to $(hostname)!",
    ]
  }

  initialization {
    dns {
      server = "8.8.8.8"
    }
  }

}