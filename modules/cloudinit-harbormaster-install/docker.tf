locals {
  docker_install_task = module.docker_install.task
}

module "docker_install" {
  source = "../cloudinit-docker-install"
}
