## Known Issues

- Upgrading proxmox provider to a version >= 0.39.0 results in a timeout when resizing disks on local-hdd

## TODO

### meta-data file

The cloud-init system supports a 'meta-data' file which can provide arbitrary, cloud-specific metadata about the instance (such as cloud provider, region, instance ID, etc.) See the cloud-init docs for more information: 

- https://cloudinit.readthedocs.io/en/latest/reference/datasources/nocloud.html#example-meta-data
- Possibly the same as: https://cloudinit.readthedocs.io/en/latest/explanation/instancedata.html

Note that it seems possible to use metadata as template variables in the user-data and other cloud-config yaml files.

Proxmox creates a meta-data file with a random instance-id, like the following:

```
instance-id: 608643f804b534e7d15895deb31fde5aa7e9c155
```

We might be able to use this for more advanced provisioning.