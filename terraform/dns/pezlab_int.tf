resource "powerdns_zone" "pezlab_lan" {
  name         = "pezlab.lan."
  kind         = "Master"
  soa_edit_api = "DEFAULT"
  nameservers = [
    "pdns-1.pezlab.lan.",
    "pdns-2.pezlab.lan."
  ]
}

resource "powerdns_zone" "pezlab_lan_slave" {
  name     = "pezlab.lan."
  kind     = "Slave"
  masters  = ["10.0.0.241"]
  provider = powerdns.secondary
}

resource "powerdns_record" "ns1_pezlab_lan" {
  zone = powerdns_zone.pezlab_lan.name

  name    = "pdns-1.pezlab.lan."
  type    = "A"
  ttl     = 86400
  records = ["10.0.0.241"]
}

resource "powerdns_record" "ns2_pezlab_lan" {
  zone = powerdns_zone.pezlab_lan.name

  name    = "pdns-2.pezlab.lan."
  type    = "A"
  ttl     = 86400
  records = ["10.0.0.242"]
}


module "pezlab_lan_records" {
  depends_on = [
    powerdns_record.ns1_pezlab_lan,
    powerdns_record.ns2_pezlab_lan
  ]

  source = "./modules/dns_record"
  for_each = {
    for vm, conf in local.extradns.pezlab_lan : vm => conf
    if !contains(["pdns-1", "pdns-2"], vm)
  }

  fwd_zone       = powerdns_zone.pezlab_lan.name
  ptr_zone       = powerdns_zone.reverse_lan_pezlab_dev.name
  reverse_record = each.value.reverse_record
  fqdn           = "${each.key}.pezlab.lan."
  ttl            = 500
  record         = each.value.ipv4
}