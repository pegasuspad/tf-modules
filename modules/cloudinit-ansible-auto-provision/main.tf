locals {
  playbook_path = "playbooks/${var.host_name}.yml"
}

data "github_repository" "ansible" {
  name = var.repository
}

data "github_repository_file" "playbook" {
  repository          = data.github_repository.ansible.name
  branch              = "main"
  file                = local.playbook_path
}

module "ansible" {
  source = "../cloudinit-ansible-provisioning-task"

  checkout           = data.github_repository_file.playbook.sha
  galaxy_collections = var.galaxy_collections
  galaxy_roles       = var.galaxy_roles
  git_url            = data.github_repository.ansible.http_clone_url
  playbook           = local.playbook_path
  vault_secret       = var.vault_secret  
}