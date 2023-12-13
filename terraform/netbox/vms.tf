resource "netbox_virtual_machine" "core_vms" {
  for_each   = local.vms
  cluster_id = netbox_cluster.pve.id
  name       = each.key
  memory_mb  = each.value.memory
  vcpus      = try(each.value.vcpus, each.value.cores)
}

resource "netbox_interface" "core_vms_eth0" {
  for_each = local.vms

  name               = "eth1"
  enabled            = true
  virtual_machine_id = netbox_virtual_machine.core_vms[each.key].id
}


resource "netbox_ip_address" "core_vms_ip" {
  for_each = local.vms

  ip_address   = "${each.value.dynamic.networks["primary"].ip}/24"
  status       = "active"
  dns_name     = "${each.key}.lan.pezlab.dev"
  interface_id = netbox_interface.core_vms_eth0[each.key].id
}

resource "netbox_primary_ip" "myvm_primary_ip" {
  for_each = local.vms

  ip_address_id      = netbox_ip_address.core_vms_ip[each.key].id
  virtual_machine_id = netbox_virtual_machine.core_vms[each.key].id
}

resource "netbox_ip_address" "extra_dns_ip" {
  for_each = local.extradns

  ip_address = "${each.value.ipv4}/24"
  status = "active"
  dns_name = "${each.key}.lan.pezlab.dev"
}