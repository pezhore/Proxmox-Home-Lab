#################################################
# locals.tf
#
# This file contains the local variables for the Terraform configuration.

locals {
  config = yamldecode(file("./external/config.yml"))
  vm_ds = element(data.proxmox_virtual_environment_datastores.lab.datastore_ids,
    index(
      data.proxmox_virtual_environment_datastores.lab.datastore_ids,
      "vms"
    )
  )
  file_ds = element(data.proxmox_virtual_environment_datastores.lab.datastore_ids,
    index(
      data.proxmox_virtual_environment_datastores.lab.datastore_ids,
      "cephfs"
    )
  )
  container_ds = element(data.proxmox_virtual_environment_datastores.lab.datastore_ids,
    index(
      data.proxmox_virtual_environment_datastores.lab.datastore_ids,
      "ds1618"
    )
  )
}