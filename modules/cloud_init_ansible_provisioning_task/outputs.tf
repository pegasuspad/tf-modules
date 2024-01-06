output "apt_sources" {
  description = "Configuration for the Ansible apt source."
  value       = {
    "ansible-jammy.list" = {
      keyid = "6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367",
      source ="deb http://ppa.launchpad.net/ansible/ansible/ubuntu jammy main"
    }
  }
}

output "packages" {
  description = "OS packages needed for ansible provisioning."
  value       = [
    "ansible-core",
    "git"
  ]
}

output "runcmd" {
  description = "Set of shell commands to run for this task."
  value       = [
    "ansible-pull ${local.ansible_arguments}"
  ]
}

output "write_files" {
  description = "Write necessary configuration for Ansible provisioning."
  value       = local.ansible_vault_secret == null ? [] : [
    {
      content: local.ansible_vault_secret,
      owner: "root:root",
      path: "/etc/runtime-metadata/ansible-vault-secret",
      permissions: "0400",
    }
  ]
}
