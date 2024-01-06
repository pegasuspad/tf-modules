variable "data_disk_attachment" {
  description = <<EOT
Configuration for how to format and mount the VM's data disk(s), if any. Must be a list of objects, each entry of which 
defines a data disk to attach. Each disk attachment configuration has the following properties:
  
  - label: volume label to apply to the disk's filesystem [Default: disk<N>]
  - mountpoint: mount point at which the disk will be attached
  - read_only: whether this disk should be mounted as a read-only filesystem or not [Default: false]
EOT
  nullable    = false
  type        = list(object({
    label        = optional(string)
    mountpoint   = string
    read_only    = optional(bool)
  }))
}
