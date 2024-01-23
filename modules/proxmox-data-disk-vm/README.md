# data_disk_virtual_machine - tf-proxmox

Creates a Proxmox virtual machine that is not intended to be booted, but will simply "hold" disks to
be mounted by another, [primary VM](../virtual_machine). This is done so that the primary VM can be
destroyed or recreated without losing the disks.
