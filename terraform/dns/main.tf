resource "powerdns_zone" "lan_pezlab_dev" {
  name         = "lan.pezlab.dev."
  kind         = "Master"
  soa_edit_api = "DEFAULT"
  nameservers = [
    "pdns-1.lan.pezlab.dev.",
    "pdns-2.lan.pezlab.dev."
  ]
}

resource "powerdns_zone" "lan_pezlab_dev_slave" {
  name     = "lan.pezlab.dev."
  kind     = "Slave"
  masters  = ["10.0.0.241"]
  provider = powerdns.secondary
}

resource "powerdns_zone" "reverse_lan_pezlab_dev" {
  name         = "10.in-addr.arpa."
  kind         = "Master"
  soa_edit_api = "DEFAULT"
  nameservers = [
    "pdns-1.lan.pezlab.dev.",
    "pdns-2.lan.pezlab.dev."
  ]
}

resource "powerdns_zone" "reverse_lan_pezlab_dev_slave" {
  name     = "10.in-addr.arpa."
  kind     = "Slave"
  masters  = ["10.0.0.241"]
  provider = powerdns.secondary
}

resource "powerdns_record" "ns1_lan_pezlab_dev" {
  zone = powerdns_zone.lan_pezlab_dev.name

  name    = "pdns-1.lan.pezlab.dev."
  type    = "A"
  ttl     = 86400
  records = ["10.0.0.241"]
}

resource "powerdns_record" "ns2_lan_pezlab_dev" {
  zone = powerdns_zone.lan_pezlab_dev.name

  name    = "pdns-2.lan.pezlab.dev."
  type    = "A"
  ttl     = 86400
  records = ["10.0.0.242"]
}


module "core_records" {
  depends_on = [
    powerdns_record.ns1_lan_pezlab_dev,
    powerdns_record.ns2_lan_pezlab_dev
  ]

  source = "./modules/dns_record"
  for_each = {
    for vm, conf in local.config.core_vms : vm => conf
    if !contains(["pdns-1", "pdns-2"], vm)
  }

  fwd_zone = powerdns_zone.lan_pezlab_dev.name
  ptr_zone = powerdns_zone.reverse_lan_pezlab_dev.name
  fqdn     = "${each.key}.${local.config.lab.fqdn}."
  ttl      = 500
  record   = each.value.ipv4
}

module "extra_records" {
  depends_on = [
    powerdns_record.ns1_lan_pezlab_dev,
    powerdns_record.ns2_lan_pezlab_dev
  ]

  source = "./modules/dns_record"
  for_each = {
    for vm, conf in local.config.extra_dns : vm => conf
    if !contains(["pdns-1", "pdns-2"], vm)
  }

  fwd_zone       = powerdns_zone.lan_pezlab_dev.name
  ptr_zone       = powerdns_zone.reverse_lan_pezlab_dev.name
  reverse_record = each.value.reverse_record
  fqdn           = "${each.key}.${local.config.lab.fqdn}."
  ttl            = 500
  record         = each.value.ipv4
}