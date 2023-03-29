data "vault_generic_secret" "terraform" {
  path = "homelab/terraform"
}

data "vault_generic_secret" "pdns" {
  path = "homelab/software/pdns"
}

data "vault_generic_secret" "shared" {
  path = "homelab/shared"
}