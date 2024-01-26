variable "key" {
  # @todo - validate this is a valid path 
  description = "Unique key within the repository at which the configuration was stored."
  nullable    = false
  type        = string
}

variable "repository" {
  description = "Name of the repository to which the configuration data was saved."
  nullable    = false
  type        = string
}
