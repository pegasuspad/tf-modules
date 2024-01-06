variable "init_tasks" {
  description = <<EOT
List of tasks which will contribute to the generated vendor data. Each task may include any of the following
optional values:

  - apt_sources: additional set of apt sources to use for package installation
  - packages: set of OS packages to install via `apt`
  - runcmd: list of shell commands to run during provisioning
  - write_files: list of files to write to the disk during provisioning

The `runcmd` commands will be invoked in the given order. The commands for each `init_task` will be executed
in the order provided to this variable.

More information on the specific parameters for each option can be found in the cloud-init documentation:

  - apt_sources: https://cloudinit.readthedocs.io/en/latest/reference/modules.html#apt-configure
  - write_files: https://cloudinit.readthedocs.io/en/latest/reference/modules.html#write-files
EOT
  default = []
  type = list(object({
    packages = optional(list(string))
    runcmd   = optional(list(string))
    
    write_files = optional(list(object({
      append      = optional(bool)
      content     = optional(string)
      defer       = optional(bool)
      encoding    = optional(string)
      owner       = optional(string)
      path        = string
      permissions = optional(string)
    })))
    
    apt_sources = optional(map(object({
      source   = optional(string)
      keyid    = optional(string)
      key      = optional(string)
      filename = optional(string)
      append   = optional(bool)
    })))
  }))
}

variable "proxmox_node" {
  description = "Node name of the Proxmox server to create the snippet on."
  type        = string
}

variable "snippets_datastore_id" {
  description = "ID of the Promox datastore to which cloudinit snippets should be saved."
  type        = string
}
