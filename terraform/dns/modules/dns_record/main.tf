resource "powerdns_record" "a" {
    zone = var.fwd_zone

    name = var.fqdn
    type = "A"
    ttl = var.ttl
    records = [var.record]
}

resource "powerdns_record" "ptr" {
    count = var.reverse_record ? 1 : 0
    zone = var.ptr_zone

    name = join(".", [join(".", reverse(split(".",var.record))), "in-addr.arpa."])

    records = [var.fqdn]
    type = "PTR"
    ttl = var.ttl
}