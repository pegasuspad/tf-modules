locals {
  merged_disk_config = [ for i, config in var.disk_config : merge(var.disk_config[i], proxmox_virtual_environment_vm.main.disk[i]) ]
}

output "attached_disks" {
  description = "Configuration details of the attached data disks."
  value       = local.merged_disk_config
}

output "data_disk_vm" {
  description = "VMID of the virtual machine to which the data disks are attached"
  value       = proxmox_virtual_environment_vm.main
}

output "disk_setup_task" {
  description = <<EOT
A cloud-init setup task (usable as an `init_tasks` value for the `proxmox-cloudinit-vendor-data` module) that will format and mount
the disks held by this data_disk_virtual_machine. Should be used as part of the cloud-init vendor data in the primary VM 
using them.
EOT
  value       = module.disk_setup_task
}

output "name" {
  description = "Name of the created virtual machine."
  value       = proxmox_virtual_environment_vm.main.name
}

output "vmid" {
  description = "vmid of the created virtual machine."
  value       = proxmox_virtual_environment_vm.main.vm_id
}