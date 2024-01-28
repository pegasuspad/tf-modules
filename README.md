# tf-modules

Reusable modules used to define Pegasus infrastructure.

## Modules

### cloudinit-harbormaster-install

Data module which defines cloud-init tasks that install and configure Harbormaster for a host. This module must be configured with a repository that has the following structure:

- **hosts**: root directory for all hosts defined in this repository
- **hosts/[HOSTNAME]**: root directory for a single host definition
- **hosts/[HOSTNAME]/_harbormaster.yml**: Harbormaster configuration file for a host
