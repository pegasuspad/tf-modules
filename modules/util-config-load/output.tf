output "data" {
  description = "The stored configuration data, as a string."
  value       = data.github_repository_file.config_file.content
}