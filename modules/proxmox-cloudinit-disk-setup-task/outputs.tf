output "runcmd" {
  description = "Set of shell commands to run for this task."
  value       = [
    "/root/setup-disks.sh",
    "mount --all",
  ]
}

output "write_files" {
  description = "Write necessary configuration for Ansible provisioning."
  value       = [
    {
      content: templatefile("${path.module}/setup-disks.tftpl", {
        labels          = local.setup_disks_labels
        mountpoints     = local.setup_disks_mountpoints
        read_only_flags = local.setup_disks_read_only_flags
      }),
      path: "/root/setup-disks.sh",
      permissions: "0755",
    }
  ]
}
