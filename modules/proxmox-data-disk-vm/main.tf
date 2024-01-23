resource "proxmox_virtual_environment_vm" "main" {
  name      = var.name
  node_name = var.proxmox_node
  on_boot   = false
  started   = false
  vm_id     = var.vmid

  tags = [
    "never-start"
  ]

  dynamic "disk" {
    for_each = var.disk_config

    content {
      datastore_id = disk.value.datastore_id
      file_format  = contains(var.block_datastore_ids, disk.value.datastore_id) ? "raw" : "qcow2"
      interface    = "scsi${disk.key}"
      iothread     = true
      size         = disk.value.size
      ssd          = contains(var.ssd_datastore_ids, disk.value.datastore_id)
    }
  }

  # do not allow our data disks to be automatically destroyed
  # lifecycle {
  #   prevent_destroy = true
  # }
}

module "disk_setup_task" {
  source = "../proxmox-cloudinit-disk-setup-task"
  disk_config = var.disk_config
}
