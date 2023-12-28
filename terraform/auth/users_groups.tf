resource "freeipa_user" "service_accts" {
  for_each      = local.auth.service
  first_name    = each.value.first_name
  last_name     = each.value.last_name
  name          = each.key
  email_address = each.value.email_address
}

resource "freeipa_user" "admin_accts" {
  for_each      = local.auth.admins
  first_name    = each.value.first_name
  last_name     = each.value.last_name
  name          = each.key
  email_address = each.value.email_address
}

resource "freeipa_group" "group" {
  for_each    = local.auth.groups
  name        = each.key
  description = "Group for ${each.key}"
}

resource "freeipa_user_group_membership" "admins" {
  for_each = {for k,v in local.auth.group_members.admins: k => v}
  user     = each.value
  name     = "admins"
}

resource "freeipa_user_group_membership" "service" {
  for_each = {for k,v in local.auth.group_members.service: k => v}
  user     = each.value
  name     = "service"
}

resource "freeipa_user_group_membership" "vault_admins" {
    for_each = {for k,v in local.auth.group_members.vault_admins: k => v}
    user = each.value
    name = "vault_admins"
}