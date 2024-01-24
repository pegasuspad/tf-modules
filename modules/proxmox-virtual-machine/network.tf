locals {
  // constants
  mac_prefix      = "aa"
  default_netmask = "255.255.255.0"

  # Essentially, if the second hex digit is 2, 6, A, or E, it is a private MAC:
  #   x2:xx:xx:xx:xx:xx
  #   x6:xx:xx:xx:xx:xx
  #   xA:xx:xx:xx:xx:xx
  #   xE:xx:xx:xx:xx:xx
  mac_address = format("${local.mac_prefix}:%02x:%02x:%02x:%02x:%02x",
    random_integer.mac_bytes[0].result,
    random_integer.mac_bytes[1].result,
    random_integer.mac_bytes[2].result,
    random_integer.mac_bytes[3].result,
    random_integer.mac_bytes[4].result
  )

  netmask            = var.network_config.netmask == null ? local.default_netmask : var.network_config.netmask
  search_domain      = var.network_config.dns_search_domain == null ? null : [var.network_config.dns_search_domain]
  default_dns_server = var.network_config.gateway
  dns_server         = [var.network_config.dns_server == null ? local.default_dns_server : var.network_config.dns_server]

  network_config_data = yamlencode({
    version = 1
    config = [
      {
        type        = "physical"
        mac_address = local.mac_address
        name        = "eth0"
        subnets = [
          {
            address = var.network_config.ip_address
            gateway = var.network_config.gateway
            netmask = local.netmask
            type    = "static"
          }
        ]
      },
      {
        type    = "nameserver"
        address = local.dns_server
        search  = local.search_domain
      }
    ]
  })

  network_config_hash = md5(local.network_config_data)
}

resource "random_integer" "mac_bytes" {
  count = 5
  min   = 0
  max   = 255
}

resource "proxmox_virtual_environment_file" "cloudinit_network_data" {
  count = var.network_config == null ? 0 : 1

  content_type = "snippets"
  datastore_id = var.snippets_datastore
  node_name    = var.proxmox_node
  overwrite    = true

  source_raw {
    data      = local.network_config_data
    file_name = "${var.name}-network-config-${local.network_config_hash}.yml"
  }
}