#===============================================================================
# Cloud Config (cloud-init)
#===============================================================================

resource "proxmox_virtual_environment_file" "user_config" {
  content_type = "snippets"
  datastore_id = local.datastore_id
  node_name    = data.proxmox_virtual_environment_datastores.lab.node_name

  source_raw {
    data = <<EOF
#cloud-config
chpasswd:
  list: |
    ubuntu:example
  expire: false
hostname: terraform-provider-proxmox-example
users:
  - default
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    ssh-authorized-keys:
      - ${data.vault_generic_secret.terraform.data["pm_public_key"]}
    sudo: ALL=(ALL) NOPASSWD:ALL
    EOF

    file_name = "terraform-provider-proxmox-example-user-config.yaml"
  }
}

resource "proxmox_virtual_environment_file" "vendor_config" {
  content_type = "snippets"
  datastore_id = local.datastore_id
  node_name    = data.proxmox_virtual_environment_datastores.lab.node_name

  source_raw {
    data = <<EOF
#cloud-config
runcmd:
    - apt update
    - apt install -y qemu-guest-agent
    - systemctl enable qemu-guest-agent
    - systemctl start qemu-guest-agent
    - echo "done" > /tmp/vendor-cloud-init-done
    EOF

    file_name = "terraform-provider-proxmox-example-vendor-config.yaml"
  }
}


#===============================================================================
# Ubuntu Cloud Images
#===============================================================================

resource "proxmox_virtual_environment_file" "ubuntu" {
  for_each = local.config.cloud_images
  content_type = "iso"
  datastore_id = local.datastore_id
  node_name    = data.proxmox_virtual_environment_datastores.lab.node_name

  source_file {
    path = "https://cloud-images.ubuntu.com/${each.key}/current/${each.key}-server-cloudimg-amd64.img"
  }
}

resource "proxmox_virtual_environment_file" "ubuntu_container_template" {
  content_type = "vztmpl"
  datastore_id = local.datastore_id
  node_name    = data.proxmox_virtual_environment_datastores.lab.node_name

  source_file {
    path = "http://download.proxmox.com/images/system/ubuntu-18.04-standard_18.04.1-1_amd64.tar.gz"
  }
}