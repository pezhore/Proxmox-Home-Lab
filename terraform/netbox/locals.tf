#################################################
# locals.tf
#
# This file contains the local variables for the Terraform configuration.

locals {
  extradns = yamldecode(file("../external/dns.yml"))
  lab = yamldecode(file("../external/lab.yml"))
  vms = yamldecode(file("../external/vms.yml"))
}