output "revision_id" {
  description = "Unique ID that changes each time the VM is updated"
  value       = random_id.revision_id.hex
}

output "vmid" {
  description = "Proxmox ID for the created VM"
  value       = proxmox_virtual_environment_vm.main.id
}

output "ip_address" {
  description = "IPv4 address for the created VM"
  value       = proxmox_virtual_environment_vm.main.ipv4_addresses[1][0]
}
