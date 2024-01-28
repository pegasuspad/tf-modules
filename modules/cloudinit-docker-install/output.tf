locals {
  apt_sources = {
    "docker.list" = {
      keyid  = "9DC858229FC7DD38854AE2D88D81803C0EBFCD88"
      source = "deb [arch=amd64] https://download.docker.com/linux/ubuntu $RELEASE stable"
    }
  }

  packages = [
    "containerd.io",
    "docker-buildx-plugin",
    "docker-ce",
    "docker-ce-cli",
    "docker-compose-plugin",
  ]

  task = {
    apt_sources = local.apt_sources
    packages    = local.packages 
  }
}

output "task" {
  description = "The cloud-init task definition."
  value       = local.task
}