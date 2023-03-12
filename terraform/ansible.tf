#################################################
# ansible.tf
#
# This file contains the resources to generate a dynamic inventory file for
# Ansible.

resource "local_file" "ansible_inventory" {
  content = templatefile("external/inventory.tmpl",
    {
      lab_vms = proxmox_virtual_environment_vm.core
      fqdn    = local.config.lab.fqdn
    }
  )
  filename = "../ansible/lab-inventory.ini"
}