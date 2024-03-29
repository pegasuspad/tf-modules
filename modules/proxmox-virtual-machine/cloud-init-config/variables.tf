variable "hostname" {
  description = "The hostname to set."
  type        = string
}

variable "init_tasks" {
  description = <<EOT
List of tasks which will contribute to the generated cloud-config. Each task may include any of the following
optional values:

  - apt_sources: additional set of apt sources to use for package installation
  - extra_config: any additional cloud-config module configurations to merge in.
  - packages: set of OS packages to install via `apt`
  - runcmd: list of shell commands to run during provisioning
  - write_files: list of files to write to the disk during provisioning

The `runcmd` commands will be invoked in the given order. The commands for each `init_task` will be executed
in the order provided to this variable. 

The `extra_config` value will be appended directly to the cloud-config file, and can contain any arbitrary 
cloud-config modules. Note that, to avoid creating invalid Yaml with  duplicate keys, the following keys should 
not be configured this way:

  - hostname
  - manage_etc_hosts
  - package_update
  - package_upgrade
  - packages
  - runcmd
  - users
  - write_files

Additionally, if multiple init_tasks are used, care should be taken to avoid including tasks that define
the same top-level cloud-config keys.

More information on the specific parameters for each option can be found in the cloud-init documentation:

  - apt_sources: https://cloudinit.readthedocs.io/en/latest/reference/modules.html#apt-configure
  - write_files: https://cloudinit.readthedocs.io/en/latest/reference/modules.html#write-files
EOT
  default = []
  type = list(object({
    extra_config = optional(string)
    packages     = optional(list(string))
    runcmd       = optional(list(string))
    
    apt_sources = optional(map(object({
      source   = optional(string)
      keyid    = optional(string)
      key      = optional(string)
      filename = optional(string)
      append   = optional(bool)
    })))

    write_files = optional(list(object({
      append      = optional(bool)
      content     = optional(string)
      defer       = optional(bool)
      encoding    = optional(string)
      owner       = optional(string)
      path        = string
      permissions = optional(string)
    })))
  }))
}

variable "proxmox_node" {
  description = "Node name of the Proxmox server to create the snippet on."
  type        = string
}

variable "snippets_datastore" {
  description = "ID of the Promox datastore to which cloud-config snippets should be saved."
  type        = string
}

variable "users" {
  default     = []
  description = <<EOT
Options for configuring users during initialization, via the cloud-init Users and Groups module. Each item
in the list contains the following options:

  - ssh_authorized_keys: list of authorized SSH keys to add for this user [Default: none]
  - ssh_import_id: list of ssh ids to import for user see https://manpages.ubuntu.com/manpages/noble/en/man1/ssh-import-id.1.html [Default: none]
  - sudo: whether this user will have sudo rights (`ALL=(ALL) NOPASSWD:ALL`) or not [Default: false]
  - username: name of the user to create [Required]
EOT
  nullable    = false
  type        = list(object({
    ssh_authorized_keys = optional(list(string), null)
    ssh_import_id       = optional(list(string), null)
    sudo                = optional(bool, false)
    username            = string
  }))
}