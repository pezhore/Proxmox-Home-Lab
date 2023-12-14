# Proxmox-Home-Lab
Packer, Terraform, and Ansible code to run a three node clustered Proxmox Home Lab


## Requirements

* [Packer](https://www.packer.io/)
* [Terraform](https://www.terraform.io/)
* [Ansible](https://www.ansible.com/)
* [Proxmox](https://www.proxmox.com/en/)
* [Hashicorp Vault](https://www.vaultproject.io/)
* [Proxmoxer Python Library](https://pypi.org/project/proxmoxer/)

## Assumptions

Three node Proxmox cluster installed with shared storage.

### Automation and Responsibilities

Ansible will handle:
- Cloud Image creation
- Ceph Installation
- Proxmox VLAN setup
- Post deployment software installation/configuration

Terraform will handle:
- VM deployment
- DNS management
- Netbox

## Order of Operations

1. Install Proxmox on each node, using xfs for storage, leaving the 2TB NVMe drive untouched for future Ceph configuration
2. Join the hosts to a cluster
3. Run the bootstrap ansible playbook to install prerequisites, and do base configuration
4. Run the `vlan_setup.yml` playbook to configure networks
5. Configure Ceph
6. Configure NFS share for Synology DS1618
7. Run the `deploy-prep.yml` to handle the creation of the cloud init template
8. Run terraform to deploy vms
9. Run ansible to configure PowerDNS/Netox
10. Run terraform to handle dns/netbox things

## Known Issues

### PowerDNS

To generate a new salt for powerdns admin:

```
source flask/bin/activate
export FLASK_APP=./powerdnsadmin/__init__.py
python -c 'import bcrypt; print(bcrypt.gensalt().decode())'
```

Still working on how to get PowerDNS to defer to PiHole for adblocking...

### Vault Integration

To run Terraform and pull AWS creds from Vault, update the following with your mount/field.

```
AWS_ACCESS_KEY_ID=$(vault kv get -mount=homelab -field=terraform_access_key wasabi) AWS_SECRET_ACCESS_KEY=$(vault kv get -mount=homelab -field=terraform_secret_key wasabi) terraform plan
```

## Acknowledgements

* Packer templates based on work by [Julien Brochet](https://github.com/aerialls/madalynn-packer)
* Terraform provider for Proxmox by [Telmate](https://registry.terraform.io/providers/Telmate/proxmox)
* Ceph Ansible code taken and consolidated from [peacedata0](https://github.com/peacedata0/proxmox-ansible-1)
* Synology Certs Role by [JohnVillalovos](https://github.com/JohnVillalovos/synology_certs)