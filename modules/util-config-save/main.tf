terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.0"
    }
  }
}

data "github_repository" "config" {
  name = var.repository
}

resource "github_repository_file" "config_file" {
  repository          = data.github_repository.config.name
  branch              = "main"
  file                = var.key
  content             = var.data
  commit_message      = "Update Terraform config (util-config-save module)"
  commit_author       = "Terraform User"
  commit_email        = "terraform@pegasuspad.com"
  overwrite_on_create = true
}
