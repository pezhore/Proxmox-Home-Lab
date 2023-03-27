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

1. Terraform will handle 

## Order of Operations

1. Install Proxmox on each node, using xfs for storage, leaving the 2TB NVMe drive untouched for future Ceph configuration
2. Join the hosts to a cluster
3. Run the bootstrap ansible playbook to install prerequisites, and do base configuration
4. `scp` the network configuration and apply (setting up the proper bond/bridge interfaces)
5. Configure Ceph
6. Configure NFS share for Synology DS1618
7. Run Terraform to do things

## Known Issues

### Packer

Packer templates need to have a `cloud-init` drive added with the following commands (replace `9000` with the VM ID)

```bash
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot order=scsi0
qm set 9000 --serial0 socket --vga serial0
```

### Terraform

Proxmox really doesn't like to have multiple VMs created from the same template simulateously. to fix this, add
`-parallelism=1` to the `terraform apply` command.

## Acknowledgements

* Packer templates based on work by [Julien Brochet](https://github.com/aerialls/madalynn-packer)
* Terraform provider for Proxmox by [Telmate](https://registry.terraform.io/providers/Telmate/proxmox)
* Ceph Ansible code taken and consolidated from [peacedata0](https://github.com/peacedata0/proxmox-ansible-1)