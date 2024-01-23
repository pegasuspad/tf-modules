variable "git_url" {
  description = "URL of the Git repository containing the Ansible provisioning playbook."
  type        = string
}

variable "playbook" {
  default     = "ansible/playbook.yml"
  description = "Git repository-relative path to the playbook to invoke."
  type        = string
}

variable "vault_secret" {
  default     = null
  description = "Secret used to access Vault-encrypted values in the Ansible configuration."
  sensitive   = true
  type        = string
}
