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

data "github_repository_file" "config_file" {
  repository          = github_repository.config.name
  branch              = "main"
  file                = var.key
}
