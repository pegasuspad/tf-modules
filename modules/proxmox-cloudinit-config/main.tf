locals {
  default_packages       = ["qemu-guest-agent"]
  default_runcmd         = [
    "systemctl start qemu-guest-agent",
    "reboot"
  ]

  init_tasks_packages    = flatten([for task in var.init_tasks : task.packages == null ? [] : task.packages])
  init_tasks_runcmd      = flatten([for task in var.init_tasks : task.runcmd == null ? [] : task.runcmd])

  # extract the "apt_sources" from each init_task, and omit null values
  init_tasks_apt_sources = [for task in var.init_tasks : task.apt_sources == null ? {} : { 
    for k, v in task.apt_sources : k => {
      for prop, value in v : prop => value if value != null
    }
  }]

  # extract the "write_files" from each init_task, and omit null values
  init_tasks_write_files = flatten([for task in var.init_tasks : task.write_files == null ? [] : [ 
    for v in task.write_files : {
      for prop, value in v : prop => value if value != null
    }
  ]])

  # map our input properties to the cloud-init param names
  users_with_nulls = [
    for user in var.users : {
      name                = user.username
      ssh_authorized_keys = user.ssh_authorized_keys
      ssh_import_id       = user.ssh_import_id
      sudo                = user.sudo ? "ALL=(ALL) NOPASSWD:ALL" : null
      plain_text_passwd   = "foobar"
    }
  ]
  # create a "users" list  without null values
  users = [
    for user in local.users_with_nulls : {
      for prop, value in user : prop => value if value != null
    }
  ]

  content = templatefile(
    "${path.module}/cloud-config.yml.tftpl",
    {
      apt_sources = merge(local.init_tasks_apt_sources...)
      hostname    = var.hostname
      os_packages = toset(sort(concat(
        local.init_tasks_packages,
        local.default_packages
      )))
      runcmd      = concat(local.init_tasks_runcmd, local.default_runcmd)
      users       = local.users
      write_files = concat(local.init_tasks_write_files)
    }
  )
  content_hash = md5(local.content)
}

resource "proxmox_virtual_environment_file" "cloudinit_vendor_data" {
  content_type = "snippets"
  datastore_id = var.snippets_datastore
  node_name    = var.proxmox_node
  overwrite    = true

  source_raw {
    data      = local.content 
    file_name = "${var.hostname}-cloud-config-${local.content_hash}.yml"
  }
}
