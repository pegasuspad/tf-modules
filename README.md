# tf-modules

Reusable modules used to define Pegasus infrastructure.

## Naming Conventions

### Module Prefixes

- **cloudinit-**: cloud-init setup tasks for the proxmox-virtual-machine module
- **pegasus-**: modules that encode site-specific conventions for the Pegasus
- **proxmox-**: modules that provision Proxmox resources
- **util-**: generic utility modules

## Modules

### cloudinit-harbormaster-install

Data module which defines cloud-init tasks that install and configure Harbormaster for a host. This module must be configured with a repository that has the following structure:

- **hosts**: root directory for all hosts defined in this repository
- **hosts/[HOSTNAME]**: root directory for a single host definition
- **hosts/[HOSTNAME]/_harbormaster.yml**: Harbormaster configuration file for a host

### pegasus-attached-disk-config

Data module that exports the necessary configuration to attach the disks from a data VM to another virtual machine. This configuration includes a description of the exported disks (mountpoint, size, path on the Proxmox node, etc.) as well as a cloud-init task that will properly format and mount those disks.

For more information see the module's outputs, as well as the following variables of the `proxmox_virtual_machine` module: `cloud_init_tasks`, `data_disk_config`.