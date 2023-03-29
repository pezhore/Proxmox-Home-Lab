variable "fwd_zone" {
    description = "PowerDNS Forward Zone Name"
}

variable "ptr_zone" {
    description = "PowerDNS Reverse Zone Name"
}

variable "fqdn" {
    description = "Record Fully Qualified Domain Name"
}

variable "ttl" {
    description = "Record Time to Live"
    default = 300
}

variable "record" {
    description = "IP Address"
}