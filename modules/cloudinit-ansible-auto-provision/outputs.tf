output "task" {
  description = "The cloud-init task definition."
  value = module.ansible.task
}
