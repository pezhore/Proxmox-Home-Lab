resource "netbox_virtual_machine" "core_vms" {
  for_each   = local.config.core_vms
  cluster_id = netbox_cluster.pve.id
  name       = each.key
  memory_mb  = each.value.memory
  vcpus      = each.value.vcpus
}

resource "netbox_interface" "core_vms_eth0" {
  for_each = local.config.core_vms

  name               = "eth1"
  enabled            = true
  virtual_machine_id = netbox_virtual_machine.core_vms[each.key].id
}


resource "netbox_ip_address" "core_vms_ip" {
  for_each = local.config.core_vms

  ip_address   = "${each.value.ipv4}/24"
  status       = "active"
  dns_name     = "${each.key}.lan.pezlab.dev"
  interface_id = netbox_interface.core_vms_eth0[each.key].id
}

resource "netbox_primary_ip" "myvm_primary_ip" {
  for_each = local.config.core_vms

  ip_address_id      = netbox_ip_address.core_vms_ip[each.key].id
  virtual_machine_id = netbox_virtual_machine.core_vms[each.key].id
}

resource "netbox_ip_address" "extra_dns_ip" {
  for_each = local.config.extra_dns

  ip_address = "${each.value.ipv4}/24"
  status = "active"
  dns_name = "${each.key}.lan.pezlab.dev"
}