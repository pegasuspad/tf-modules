output "tasks" {
  description = "List of cloud-init task definitions needed to install and configure Harbormaster."
  value       = [local.docker_install_task, local.harbormaster_task]
}
