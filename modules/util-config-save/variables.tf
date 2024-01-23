variable "data" {
  description = "Configuration data to save, as a string."
  nullable    = false
  type        = string
}

variable "key" {
  # @todo - validate this is a valid path 
  description = "Unique key within the repository at which the configuration will be stored."
  nullable    = false
  type        = string
}

variable "repository" {
  description = "Name of the repository used to store configuration data."
  nullable    = false
  type        = string
}
