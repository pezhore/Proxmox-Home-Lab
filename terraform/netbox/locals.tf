#################################################
# locals.tf
#
# This file contains the local variables for the Terraform configuration.

locals {
  config = yamldecode(file("../external/config.yml"))
}