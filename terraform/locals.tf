#################################################
# locals.tf
#
# This file contains the local variables for the Terraform configuration.

locals {
  config = yamldecode(file("./external/config.yml"))
  datastore_id = element(data.proxmox_virtual_environment_datastores.lab.datastore_ids,
    index(
      data.proxmox_virtual_environment_datastores.lab.datastore_ids,
      "ds1618"
    )
  )
}