resource "proxmox_vm_qemu" "core" {
  depends_on = [
    proxmox_virtual_environment_file.user_config,
    proxmox_virtual_environment_file.vendor_config
  ]
  provider = telmate
  for_each = local.vms

  name        = each.key
  desc        = each.value.desc
  target_node = each.value.pve_node

  # Setting the OS type to cloud-init
  os_type = "cloud-init"
  # Set to the name of the cloud-init VM template created earlier
  clone = local.lab.templates[each.value.template].name
  # Ensure each VM is cloned in full to avoid
  # dependency to the original VM template
  full_clone = true
  preprovision = false

  cores   = each.value.cores
  memory  = each.value.memory
  cpu     = try(each.value.cpu, "host")
  vcpus   = try(each.value.vcpus, 0)
  sockets = try(each.value.sockets, 1)

  # Define a static IP on the primary network interface
  ipconfig0 = "ip=${each.value.dynamic.networks.primary.ip}/24,gw=${local.networks[each.value.dynamic.networks.primary.net].gateway}"
  # ipconfig {
  #   config = "ip=${each.value.dynamic.networks.primary.ip}/24,gw=${local.networks[each.value.dynamic.networks.primary.net].gateway}"
  # }
  
  dynamic "network" {
    for_each = each.value.dynamic.networks

    content {
      bridge    = local.networks[network.value.net].bridge
      firewall  = network.value.firewall
      link_down = network.value.link_down
      model     = network.value.model
    }
  }

  ciuser                 = local.lab.ciuser
  cicustom               = "user=${try(each.value.cloudinit_storage, "ds1618")}:snippets/${each.key}-user-config.yaml,vendor=ds1618:snippets/agent_install-vendor-config.yaml"
  define_connection_info = true
  onboot                 = try(each.value.autostart, false)

  # Always include the terraform tag, but extra tags can be provided. We must
  # sort to ensure subsequnt runs don't make changes
  tags = join(";", sort(concat(["terraform"], [for item in each.value.tags : item])))

  # Enable the QEMU guest agent
  agent = 1


  scsihw = each.value.scsihw
  dynamic "disk" {
    for_each = { for idx, d in each.value.dynamic.disks : idx => d }

    content {
      type    = disk.value.type
      storage = disk.value.storage
      size    = disk.value.size
      format  = disk.value.format
      #ssd     = local.lab.storage[disk.value.storage].ssd
      discard = try(disk.value.discard, null)
    }
  }


  lifecycle {
    ignore_changes = [
      target_node,
      network,
      clone,
      full_clone,
      qemu_os
    ]
  }
}
