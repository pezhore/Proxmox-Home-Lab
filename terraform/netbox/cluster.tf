
resource "netbox_cluster" "pve" {
  cluster_type_id = data.netbox_cluster_type.proxmox.id
  name            = "pve"
}