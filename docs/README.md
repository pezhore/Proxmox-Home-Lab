# Homelab Documentation

## Overview

This is a collection of documentation for my homelab - it is a work in progress. I have two goals for my homelab:

1. Provide a learning space for new-to-me techonologies/tools.
2. House tooling that I use in the rest of my home network (DNS, Ad Blocking, etc).

As my home network relies upon systems in this homelab, I strive for a certain level of security, resiliency, and ease of use.

## Hardware

### Network

I predominately use Ubiquiti Edge gear for the lab - an EdgeRouter Lite 3 for my Router/FW and the EdgeSwitch 24 Lite
for core switch responsibilities. Recently, I added a MikroTik CRS305-1G-4S+IN for fibre connectivity. The network has
minimal complexity, relying on the ERL3 for routing three VLANs:

1. Core (VLAN 10)
2. Storage (VLAN 20)
3. Storage 10G (VLAN 300)

Future expansion goals include:

1. IoT (VLAN 30) - On hold until the purchase/upgrade to a wireless mesh that supports segregated SSIDs/VLANs.
   Potentially the Netgear Orbi Pro WiFi 6 Mesh System. I have a previous model that has served me well, but it doesn't
   support different backing VLANs for the two built-in SSIDs (guest/primary)
2. VPN (VLAN 50) - I don't typically have a need to VPN into my network, but spinning up a K8S pod for Wireguard is a
   good option for learning about kubernetes and the tooling around it.

Everything has jumbo frames (MTU 9000) enabled, with the MikroTik fully populated with 10GbE SFP+ modules for Compute
and storage.

### Compute

I picked up three identically configured Lenovo M920q micro-pcs from an electronics recycling center each is equipped
with:

- Intel i7-8700T (12 Cores @ 2.4GHz)
- 24GB DDR4 RAM
- 2TB WD Black NVMe SSD (Ceph)
- 256GB Sabrent NVMe SSD (OS)
- 2x TP-Link USB Ethernet Adapters
- Mellanox MCX311A-XCAT ConnectX-3 10G Ethernet Adapter
- 10GbE SFP+

Currently, the onboard NIC is used for management and VM traffic (VLAN 10), the two USB NICs are bonded and bridged on
the Storage VLAN (VLAN 20). The Mellanox NIC is used for 10GbE storage traffic (VLAN 300) - predominately supporting
Ceph, but also used for the Synology NFS Mount.

The three Lenovo systems are running Proxmox in a cluster configuration.

There are additional systems in the mix:

- ClusterHAT Raspberry Pi 4, with 4x Raspberry Pi Zero Ws - currently housing a four node Hashicorp Vault instance.
- Raspbery Pi 4 running PiHole
- Dell Tower running Ubuntu Server - This will be decommissioned as the various services are migrated to the Proxmox
  cluster.

### Storage

Two mass storage devices are available:

1. Synology DS1618+
2. Synology DS415+

The DS1618 is used for backups, mass media storage, and an NFS mount for Proxmox. Three of the four onboard 1GbE NICs
are bonded on VLAN 20, while the fourth NIC is used for management. A recent addition was a 10GbE SFP+ NIC, which is on
VLAN 300. Total storage is 35TB

The Synology DS415 is used for secondary backups, colder storage, and docker images/containers. As containers are moved
to the Proxmox cluster, this device will be reevaluated for decommissioning. Total storage is 10TB.

## Virtual Environment

Proxmox houses several virtual machines (I'm not a fan of how containers are presented, so I'm relying on a k8s cluster
instead). All VMs are provisioned with Ansible/Terraform in the parent folder of this repository, check there for the
current list of VMs. In general there are:

- 2x PowerDNS Resolver/Recursor Servers for internal DNS
- Kubernetes Cluster (1x Master, 4x Workers) - probably overkill for the workers
- FreeIPA Server
- Netbox

Future systems will include Plex, Minecraft, and a few other containers in the k8s cluster.

## Security

Everything inside my network that can support a custom SSL certificate is using a wildcard Let's Encrypt certificate - I
need to do some automation/scripting around installing/updating certificates as they expire.

FreeIPA will be coming online shortly and used for LDAP authentication for everything that supports it.