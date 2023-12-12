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

variable "reverse_record" {
    type = bool
    description = "Optionally create a reverse record for this IP address, defaults to true"
    default = true
}