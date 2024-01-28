variable "harbormaster_directory" {
  default     = "/var/lib/harbormaster"
  description = "Root working directory for Harbormaster configuration and application data."
  nullable    = false
  type        = string
}

variable "host_name" {
  description = "Name of the host to manage, which is used to find the correct config file in the repository."
  nullable    = false
  type        = string
}

variable "repository" {
  description = "Git repository URL containing the Harbormaster config."
  nullable    = false
  type        = string
}

variable "update_interval_minutes" {
  default     = 1
  description = "How often the repository should be polled for updates (in minutes)."
  nullable    = false
  type        = number
}


