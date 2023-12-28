#################################################
# locals.tf
#
# This file contains the local variables for the Terraform configuration.

locals {

  # Pull in our config files
  lab  = yamldecode(file("../external/lab.yml"))
  auth = yamldecode(file("../external/auth.yml"))
}