# cloudinit-ansible-auto-provision - tf-modules

Given the name of a host, this module creates a cloud-init-task to provision that host. The playbook
is retrieved from a configurable Github repository with the following details:

  - Repository owner: configured for the Github provider by the calling module
  - Repository name: `var.repository`
  - Playbook name: `playbooks/${var.host_name}.yml`, relative to the repository root

If the playbook content changes, then the created task will be updated. Otherwise, the task will be
stable across multiple invocations.

For general information on cloud-init tasks, see the `cloud_init_tasks` variable description in the
[proxmox-virtual-machine module](../proxmox-virtual-machine/variables.tf).
