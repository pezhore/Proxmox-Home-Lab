#################################################
# locals.tf
#
# This file contains the local variables for the Terraform configuration.

locals {

  # Pull in our config files
  lab      = yamldecode(file("../external/lab.yml"))
  networks = yamldecode(file("../external/networks.yml"))
  vms      = yamldecode(file("../external/vms.yml"))


  # Get our datastores
  vm_ds = element(data.proxmox_virtual_environment_datastores.lab.datastore_ids,
    index(
      data.proxmox_virtual_environment_datastores.lab.datastore_ids,
      "ceph-vm"
    )
  )
  ds1618_ds = element(data.proxmox_virtual_environment_datastores.lab.datastore_ids,
    index(
      data.proxmox_virtual_environment_datastores.lab.datastore_ids,
      "ds1618"
    )
  )
  cephfs_ds = element(data.proxmox_virtual_environment_datastores.lab.datastore_ids,
    index(
      data.proxmox_virtual_environment_datastores.lab.datastore_ids,
      "cephfs"
    )
  )

  container_ds = element(data.proxmox_virtual_environment_datastores.lab.datastore_ids,
    index(
      data.proxmox_virtual_environment_datastores.lab.datastore_ids,
      "ceph-ct"
    )
  )
}