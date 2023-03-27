resource "proxmox_virtual_environment_pool" "lab" {
  comment = "Managed by Terraform"
  pool_id = "labrp"
}

resource "proxmox_virtual_environment_time" "lab" {
  for_each  = toset(local.config.lab.nodes)
  node_name = each.key
  time_zone = local.config.lab.tz
}

resource "proxmox_virtual_environment_role" "lab" {
  for_each   = local.config.lab.acls
  privileges = each.value.privileges
  role_id    = each.key
}

resource "proxmox_virtual_environment_user" "service" {
  for_each = local.config.lab.users

  comment  = "Managed by Terraform"
  password = data.vault_generic_secret.proxmox.data[each.key]
  user_id  = each.key
}