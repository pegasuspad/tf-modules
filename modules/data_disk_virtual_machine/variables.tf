variable "block_datastore_ids" {
  default     = ["local-lvm", "local-nvme"]
  description = "List of datastore IDs that are block devices. Disks in these datastores can only use the RAW format."
  type        = list(string)
}

variable "disk_config" {
  default     = []
  description = <<-EOT
Configuration for the data disk(s). Must be a list of objects, each entry of which defines a data disk to
allocate. Each disk definition has the following fields:
  
  - datastore_id: ID of the proxmox storage to which the disk will be saved.
  - label: volume label to apply to the disk's filesystem [Default: disk<N>]
  - mountpoint: mount point at which the disk will be attached
  - read_only: whether this disk should be mounted as a read-only filesystem or not [Default: false]
  - size: size of the disk, in GB
EOT
  type        = list(object({
    datastore_id = string
    label        = optional(string)
    mountpoint   = string
    read_only    = optional(bool)
    size         = number
  }))

  validation {
    condition     = length(var.disk_config) > 0
    error_message = "At least one disk definition is required."
  } 
}

variable "name" {
  description = "Name of the virtual machine."
  nullable    = false
  type        = string  
}

variable "proxmox_node" {
  description = "Node name of the Proxmox server on which to create the data disk VM."
  type        = string
}

variable "ssd_datastore_ids" {
  default     = ["local-lvm", "local-nvme"]
  description = "List of datastore IDs that are SSD or NVME devices. Disks in these datastores will have ssd emulation enabled."
  type        = list(string)
}

variable "tags" {
  default     = []
  description = "Additional tags to apply to this VM, if any."
  type        = list(string)
}

variable "vmid" {
  default     = null
  description = "VMID for the new virtual machine, which must be unique. The next available ID is assigned if unspecified."
  type        = number
}
