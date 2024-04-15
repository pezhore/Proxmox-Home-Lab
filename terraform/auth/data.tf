##################################################
# data.tf
#
# This file contains the data sources for the Terraform configuration.

data "vault_generic_secret" "terraform" {
  path = "homelab/terraform"
}

data "vault_generic_secret" "freeipa" {
  path = "homelab/software/freeipa"
}

data "vault_generic_secret" "keycloak" {
  path = "homelab/software/keycloak"
}

data "vault_generic_secret" "ldap" {
  path = "homelab/software/ldap"
}