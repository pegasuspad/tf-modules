variable "galaxy_collections" {
  default      = null
  description = "List of Galaxy collections to install. See the cloudinit-ansible-provisioning-task for details."
  type        = list(string)
}

variable "galaxy_roles" {
  default      = null
  description = "List of Galaxy roles to install. See the cloudinit-ansible-provisioning-task for details."
  type        = list(string)
}

variable "host_name" {
  description = "Name of the host being provisioned. The playbook name will be 'playbooks/<host_name>.yml'."
  nullable    = false
  type        = string
}

variable "repository" {
  description = "Name of the Github repository containing the Ansible playbook, without the owner prefix."
  nullable    = false
  type        = string
}

variable "vault_secret" {
  default     = null
  description = "Secret used to access Vault-encrypted values in the Ansible configuration."
  sensitive   = true
  type        = string
}
