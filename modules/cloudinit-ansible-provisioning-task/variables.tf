variable "checkout" {
  default     = null
  description = "The branch/tag/commit of the repository to checkout."
  type        = string
}

variable "galaxy_collections" {
  default     = []
  description = <<EOT
List of Galaxy collections to install before running the Ansible playbook. Each entry in the list
is a collection (and optional version) that could be passed to `ansible-galaxy collection install`.
Some examples include:

  - git+https://github.com/some-organization/repo.git,main
  - community.docker:>=3.6.0

See the ansible-galaxy documentation for more examples: 
https://docs.ansible.com/ansible/latest/collections_guide/collections_installing.html#installing-collections-with-ansible-galaxy
EOT
  nullable    = false
  type        = list(string)
}

variable "galaxy_roles" {
  default     = []
  description = <<EOT
List of Galaxy roles to install before running the Ansible playbook. Each entry in the list
is a role (and optional version) that could be passed to `ansible-galaxy role install`.
Some examples include:

  - geerlingguy.apache
  - stefangweichinger.ansible_rclone,0.1.2

See the ansible-galaxy documentation for more examples: 
https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles-from-galaxy
EOT
  nullable    = false
  type        = list(string)
}

variable "git_url" {
  description = "URL of the Git repository containing the Ansible provisioning playbook."
  nullable    = false
  type        = string
}

variable "playbook" {
  description = "Git repository-relative path to the playbook to invoke."
  nullable    = false
  type        = string
}

variable "vault_secret" {
  default     = null
  description = "Secret used to access Vault-encrypted values in the Ansible configuration."
  sensitive   = true
  type        = string
}
