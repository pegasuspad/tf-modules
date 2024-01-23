output "data_disk_vm" {
  description = "VMID of the virtual machine to which the data disks are attached"
  value       = proxmox_virtual_environment_vm.main
}

output "disk_config" {
  description = "Configuration of the attached data disks."
  value       = var.disk_config
}

output "disk_setup_task" {
  description = <<EOT
A cloud-init setup task (usable as an `init_tasks` value for the `proxmox-cloudinit-vendor-data` module) that will format and mount
the disks held by this data_disk_virtual_machine. Should be used as part of the cloud-init vendor data in the primary VM 
using them.
EOT
  value       = module.disk_setup_task
}
