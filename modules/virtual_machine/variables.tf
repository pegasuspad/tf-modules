variable "boot_disk" {
  description = <<-EOT
    Configuration for the VM's boot disk:
      
      - datastore_id: ID of the proxmox storage to which the disk will be saved.
      - size: size of the boot disk, in GB. [Default: 8]
  EOT
  type        = object({
    datastore_id = string
    size         = optional(number, 8)
  })
}

variable "boot_iso_id" {
  description = "ID of the ISO image from which to initialize the boot disk"
  type        = string
}

variable "category" {
  default     = "other"
  description = <<-EOT
    VM category, which applies default tags and controls the startup order.. Must be one of the following values:

      - network: network infrastructure, which starts first
      - infrastructure: other core services to start immediately, such as NFS
      - desktop: user desktops
      - internal: services used internally by the household
      - external: services accessible to external users
      - other: do not automatically start this VM

    VMs are started in the order defined above.
  EOT
  type        = string

  validation {
    condition     = contains([
      "desktop",
      "external",
      "infrastructure", 
      "internal",
      "network", 
      "other"
    ], var.category)
    error_message = "Valid values for var: category are (network, infrastructure, desktop, internal, external, and other)."
  } 
}

variable "cpu_cores" {
  default     = 2
  description = "Number of CPU cores"
  type        = number
}

variable "data_disks" {
  default = []
  description = <<-EOT
    Set of data disks to import from another non-bootable VM. This is done so the disks can be preserved in the event 
    the primary VM needs to be recreated. Must be a list of objects, each entry of which is a data disk to import. The
    structure for the list items is the same as for the proxmox_virtual_environment_vm.disk field.

    To determine how these disks are formatted and mounted, see the data_disk_attachment variable.
  EOT
  type    = list(object({
    datastore_id      = string
    file_format       = string
    path_in_datastore = string
    size              = number
    ssd               = bool
  }))
}

variable "description" {
  default     = null
  description = "Optional human-readable description"
  type        = string  
}

variable "gateway_ip" {
  default     = null
  description = "IPv4 address of the VM's internet gateway. Must not be set if using DHCP."
  nullable    = true
  type        = string
}

variable "id" {
  default     = null
  description = "VMID for the new virtual machine, which must be unique"
  nullable    = true
  type        = number
}

variable "ip_address" {
  default     = "dhcp"
  description = "IPv4 address in CIDR notation. Will use DHCP if not set."
  nullable    = false
  type        = string
}

variable "memory" {
  default     = 512
  description = "RAM allocated to this VM, in megabytes"
  type        = number
}

variable "name" {
  description = "Name for the new virtual machine"
  type        = string  
}

variable "proxmox_node_name" {
  description = "Node name of the Proxmox server on which to create the VM."
  type        = string
}

variable "ssh_keys" {
  default     = [
    # Ansible public key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4YCHwuduiKLABDLMgIh3PEQP1VPNu7nR4RB9tYFwMV sean@prod-ansible"
  ]
  description = <<EOT
Public keys that will be accepted for authentication by the default user. The default username is set via 'username'.
EOT
  nullable    = false
  type        = list(string)
}

variable "cloud_init_datastore_id" {
  description = "ID of the Promox datastore to which the cloud-init drive should be saved"
  type        = string
}

variable "cloud_init_vendor_data_file_id" {
  default     = null
  description = "ID of the snippet file containing the cloud-init vendor data."
  type        = string
}


variable "startup_delay" {
  default     = null
  description = "Optional delay, in seconds, to wait after this VM is started before starting the next one."
  type        = number
}

variable "tags" {
  default     = []
  description = "Additional tags to apply to this VM, if any."
  type        = list(string)
}

variable "username" {
  default     = "ansible"
  description = "Name of the initial user that is created on the virtual machine."
  nullable    = false
  type        = string
}
