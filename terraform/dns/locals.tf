locals {
  extradns = yamldecode(file("../external/dns.yml"))
  lab = yamldecode(file("../external/lab.yml"))
  vms = yamldecode(file("../external/vms.yml"))
}