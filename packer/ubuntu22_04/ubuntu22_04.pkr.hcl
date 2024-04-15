packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_node" {
  type    = string
  default = "pve-02"
}

variable "proxmox_template_name" {
  type    = string
  default = "ubuntu-22.04-tmpl"
}

variable "proxmox_vm_id" {
  type    = string
  default = "200"
}

variable "iso_storage_pool" {
  type    = string
  default = "ds1618"
}

variable "ubuntu_iso_file" {
  type    = string
  default = "ubuntu-22.04.3-live-server-amd64.iso"
}

variable "vm_storage_pool" {
  type    = string
  default = "ds1618"
}

variable "vm_storage_pool_type" {
  type    = string
  default = "nfs"
}

variable "ssh_username" {
  type    = string
  default = "lab"
}

locals {
  proxmox_url      = vault("homelab/data/shared", "proxmox_url")
  proxmox_username = vault("homelab/data/packer", "proxmox_username")
  proxmox_password = vault("homelab/data/packer", "proxmox_password")
  ssh_password     = vault("homelab/data/shared", "template_ssh_password")
}

source "proxmox" "pve01_ubuntu_2204" {
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- only-ubiquity autoinstall net.ifnames=0 biosdevname=0 ip=dhcp ipv6.disable=1 ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"", // IPv6 disabled to fix hang: https://answers.launchpad.net/ubuntu/+source/ubiquity/+question/698383
    "<enter><wait>",
    "initrd /casper/", // This is weird, but for some reason my proxmox/packer runs will ignore anything after '/casper/'
    "<enter><wait>",   //  so we throw in another enter/wait before typing in just 'initrd'
    "initrd<enter><wait>",
    "boot",
    "<enter>"
  ]

  boot_wait = "5s"
  cloud_init = true
  disks {
    disk_size         = "20G"
    storage_pool      = var.vm_storage_pool
    storage_pool_type = var.vm_storage_pool_type
    format            = "qcow2"
    type              = "scsi"
  }

  http_directory = "http"
  iso_file       = "${var.iso_storage_pool}:iso/${var.ubuntu_iso_file}"
  memory         = 1024

  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }

  node                     = "pve-01"
  proxmox_url              = local.proxmox_url
  insecure_skip_tls_verify = true
  username                 = local.proxmox_username
  password                 = local.proxmox_password

  ssh_username = var.ssh_username
  ssh_password = local.ssh_password
  ssh_timeout  = "200m"

  scsi_controller = "virtio-scsi-single"
  template_name   = "pve-01-${var.proxmox_template_name}"
  unmount_iso     = true
  vm_id           = "${var.proxmox_vm_id + 1}"
}

source "proxmox" "pve02_ubuntu_2204" {
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall net.ifnames=0 biosdevname=0 ip=dhcp ipv6.disable=1 ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"", // IPv6 disabled to fix hang: https://answers.launchpad.net/ubuntu/+source/ubiquity/+question/698383
    "<enter><wait>",
    "initrd /casper/", // This is weird, but for some reason my proxmox/packer runs will ignore anything after '/casper/'
    "<enter><wait>",   //  so we throw in another enter/wait before typing in just 'initrd'
    "initrd<enter><wait>",
    "boot",
    "<enter>"
  ]

  boot_wait = "5s"

  disks {
    disk_size         = "20G"
    storage_pool      = var.vm_storage_pool
    storage_pool_type = var.vm_storage_pool_type
    format            = "qcow2"
    type              = "scsi"
  }

  http_directory = "http"
  iso_file       = "${var.iso_storage_pool}:iso/${var.ubuntu_iso_file}"
  memory         = 1024

  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }

  node                     = "pve-02"
  proxmox_url              = local.proxmox_url
  insecure_skip_tls_verify = true
  username                 = local.proxmox_username
  password                 = local.proxmox_password

  ssh_username = var.ssh_username
  ssh_password = local.ssh_password
  ssh_timeout  = "200m"

  scsi_controller = "virtio-scsi-single"
  template_name   = "pve-02-${var.proxmox_template_name}"
  unmount_iso     = true
  vm_id           = "${var.proxmox_vm_id + 2}"
}

source "proxmox" "pve03_ubuntu_2204" {
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall net.ifnames=0 biosdevname=0 ip=dhcp ipv6.disable=1 ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"", // IPv6 disabled to fix hang: https://answers.launchpad.net/ubuntu/+source/ubiquity/+question/698383
    "<enter><wait>",
    "initrd /casper/", // This is weird, but for some reason my proxmox/packer runs will ignore anything after '/casper/'
    "<enter><wait>",   //  so we throw in another enter/wait before typing in just 'initrd'
    "initrd<enter><wait>",
    "boot",
    "<enter>"
  ]

  boot_wait = "5s"

  disks {
    disk_size         = "20G"
    storage_pool      = var.vm_storage_pool
    storage_pool_type = var.vm_storage_pool_type
    format            = "qcow2"
    type              = "scsi"
  }

  http_directory = "http"
  iso_file       = "${var.iso_storage_pool}:iso/${var.ubuntu_iso_file}"
  memory         = 1024

  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }

  node                     = "pve-03"
  proxmox_url              = local.proxmox_url
  insecure_skip_tls_verify = true
  username                 = local.proxmox_username
  password                 = local.proxmox_password

  ssh_username = var.ssh_username
  ssh_password = local.ssh_password
  ssh_timeout  = "200m"

  scsi_controller = "virtio-scsi-single"
  template_name   = "pve-03-${var.proxmox_template_name}"
  unmount_iso     = true
  vm_id           = "${var.proxmox_vm_id + 3}"
}

build {
  sources = ["source.proxmox.pve03_ubuntu_2204"]#,"source.proxmox.pve02_ubuntu_2204","source.proxmox.pve03_ubuntu_2204",]

  provisioner "shell" {
    inline = ["while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"]
  }

}
