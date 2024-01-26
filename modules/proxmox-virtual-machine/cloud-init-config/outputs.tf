output "file_id" {
  description = "File ID of the snippet containing the config data."
  value       = proxmox_virtual_environment_file.cloud_config.id
}
