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

## Acknowledgements

* Packer templates based on work by [Julien Brochet](https://github.com/aerialls/madalynn-packer)