output "data_disk_vm" {
  description = "VMID of the virtual machine to which the data disks are attached"
  value       = proxmox_virtual_environment_vm.main
}

output "disk_setup_task" {
  description = <<EOT
A cloud-init setup task (usable as an `init_tasks` value for the `cloud_init_vendor_data` module) that will format and mount
the disks held by this data_disk_virtual_machine. Should be used as part of the cloud-init vendor data in the primary VM 
using them.
EOT
  value       = module.disk_setup_task
}