locals {
  default_tag_sets = {
    network        = ["network"]
    infrastructure = ["infrastructure"]
    desktop        = ["desktop"]
    internal       = []
    external       = ["public"]
    other          = []  
  }

  startup_orders = {
    network        = 1000
    infrastructure = 2000
    desktop        = 3000
    internal       = 4000
    external       = 5000
    other          = null    
  }

  default_tags  = local.default_tag_sets[var.category]
  startup_order = local.startup_orders[var.category]
}

resource "proxmox_virtual_environment_vm" "main" {
  boot_order    = ["scsi0"] 
  description   = var.description
  name          = var.name
  node_name     = var.proxmox_node_name
  on_boot       = local.startup_order == null ? false : true
  scsi_hardware = "virtio-scsi-single"
  started       = true
  tags          = concat(local.default_tags, var.tags)
  vm_id         = var.id

  agent {
    enabled = true
  }

  cpu {
    cores     = var.cpu_cores
    sockets   = 1 
    type      = "host" 
  }

  disk {
    datastore_id = var.boot_disk.datastore_id
    file_id      = var.boot_iso_id
    interface    = "scsi0"
    iothread     = true
    size         = var.boot_disk.size
  }

  # See: https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#example-attached-disks
  # attached disks from disk-holder VM
  dynamic "disk" {
    for_each = { for idx, val in (length(var.data_disks) == 0 ? [] : var.data_disks) : idx => val }
    iterator = data_disk

    # assign from scsi1 and up
    content {
      datastore_id      = data_disk.value["datastore_id"]
      file_format       = data_disk.value["file_format"]
      interface         = "scsi${data_disk.key + 1}" 
      iothread          = true
      path_in_datastore = data_disk.value["path_in_datastore"]
      size              = data_disk.value["size"]
      ssd               = data_disk.value["ssd"]
    }
  }

  initialization {
    datastore_id        = var.cloud_init_datastore_id
    vendor_data_file_id = var.cloud_init_vendor_data_file_id

    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway_ip
      }
    }

    user_account {
      keys     = var.ssh_keys
      username = var.username
    }
  }
  
  memory {
    dedicated  = var.memory
  }

  network_device {
    bridge     = "vmbr0"
    model      = "virtio"
  } 

  operating_system {
    type       = "l26"
  }

  serial_device {}

  dynamic "startup" {
    for_each   = local.startup_order[*]
    
    content {
      order    = local.startup_order
      up_delay = var.startup_delay
    }
  }

  vga {
    type       = "serial0" 
  }
}
