#########################################################
#  Automated Disk Setup Script
#########################################################

# Creates the content for `/root/setup-disks.sh`, which is created during cloud init and provides
# a mechanism for automating VM disk setup.
#
# Overview:
# The `setup-disks.sh` script automates the process of identifying, formatting (if unformatted),
# and mounting additional block devices attached to the system. The script specifically targets 
# devices based on their unique serial numbers and performs actions accordingly. These serial
# numbers are set by Proxmox, and are of the form "drive-scsiN", where "scsiN" is the scsi ID
# set in the VM config.
#
# Features:
# 1. Disk Identification by Serial: Only operates on disks with serial numbers defined in the script.
# 2. Conditional Formatting: If a targeted disk isn't formatted, it gets formatted with ext4.
# 3. Volume Label Assignment: Assigns volume labels to disks based on their serial numbers.
# 4. Mounting & Persistent Mounts: Mounts the disks to specified directories and ensures they're 
#    mounted on subsequent reboots by updating `/etc/fstab` with UUID references.
#
# Configuration Arrays:
# - `SERIAL_TO_PATH`: Maps disk serial numbers to their intended mount points.
#   This array is created from the "mountpoint" values of var.data_disk_attachment entries
#
# - `SERIAL_TO_LABEL`: Maps disk serial numbers to their desired volume labels.
#   This array is created from the "label" values of var.data_disk_attachment entries
#
# Notes:
# 1. The script uses tools like `lsblk`, `blkid`, and `mkfs.ext4`. Ensure they're available.
# 2. The script has built-in logic to avoid formatting or misconfiguring the OS disk.

locals {
  # extracts the label from each configured data_disk, defaultint to "diskN" if not provided
  setup_disks_labels          = [for idx, disk in var.disk_config : disk.label == null ? "disk${idx + 1}" : disk.label]

  # extracts the mountpoint from each configured data_disk
  setup_disks_mountpoints     = var.disk_config[*].mountpoint
 
  # extracts the read_only from each configured data_disk
  setup_disks_read_only_flags = [for idx, disk in var.disk_config : disk.read_only == null ? false : disk.read_only]
}