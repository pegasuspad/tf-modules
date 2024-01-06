output "vmid" {
  description = "Proxmox ID for the created VM"
  value       = proxmox_virtual_environment_vm.main.id
}

output "ip_address" {
  description = "IPv4 address for the created VM"
  value       = proxmox_virtual_environment_vm.main.ipv4_addresses[1][0]
}
