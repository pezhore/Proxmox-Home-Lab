# Proxmox-Home-Lab
Packer, Terraform, and Ansible code to run a three node clustered Proxmox Home Lab


## Requirements

* [Packer](https://www.packer.io/)
* [Terraform](https://www.terraform.io/)
* [Ansible](https://www.ansible.com/)
* [Proxmox](https://www.proxmox.com/en/)
* [Hashicorp Vault](https://www.vaultproject.io/)

## Assumptions

Three node Proxmox cluster installed with shared storage.

## Known Issues

Packer templates need to have a `cloud-init` drive added with the following commands (replace `9000` with the VM ID)

```bash
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot order=scsi0
qm set 9000 --serial0 socket --vga serial0
```

## Acknowledgements

* Packer templates based on work by [Julien Brochet](https://github.com/aerialls/madalynn-packer)
* Terraform provider for Proxmox by [Telmate](https://registry.terraform.io/providers/Telmate/proxmox)