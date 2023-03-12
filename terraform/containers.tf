resource "proxmox_virtual_environment_container" "example_template" {
  description = "Managed by Terraform"

  disk {
    datastore_id = local.container_ds
    size         = 10
  }

  initialization {
    dns {
      server = "1.1.1.1"
    }

    hostname = "terraform-provider-proxmox-example-lxc-template"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys     = [data.http.github_ssh_keys.response_body, data.vault_generic_secret.terraform.data["pm_public_key"]]
      password = "example"
    }
  }

  network_interface {
    name = "vmbr0"
  }

  node_name = data.proxmox_virtual_environment_nodes.lab.names[0]

  operating_system {
    template_file_id = proxmox_virtual_environment_file.ubuntu_container_template.id
    type             = "ubuntu"
  }

  pool_id  = proxmox_virtual_environment_pool.lab.id
  template = true
  vm_id    = 2042

  tags = [
    "container",
    "example",
    "terraform",
  ]
}

resource "proxmox_virtual_environment_container" "example" {
  disk {
    datastore_id = local.container_ds
  }

  clone {
    vm_id = proxmox_virtual_environment_container.example_template.id
  }

  initialization {
    hostname = "terraform-provider-proxmox-example-lxc"
  }

  node_name = data.proxmox_virtual_environment_nodes.lab.names[0]
  pool_id   = proxmox_virtual_environment_pool.lab.id
  vm_id     = 2043
}
