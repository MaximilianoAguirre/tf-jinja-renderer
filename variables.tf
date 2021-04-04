###################################################################
# Data
###################################################################
variable "jinja_template" {
  description = "File to render"
  type        = string
}

variable "data" {
  description = "Data file"
  type        = string
}

variable "filters" {
  description = "Python files containing filters"
  type        = list(string)
  default     = []
}

###################################################################
# Jinja options
###################################################################
variable "allow_undefined" {
  description = "Allow undefined values without erroring out."
  type        = bool
  default     = false
}

variable "data_format" {
  description = "File format of the data file"
  type        = string
  default     = "json"

  validation {
    condition     = contains(["env", "json", "yaml", "ini"], var.data_format)
    error_message = "Must be one of: env, json, yaml, ini."
  }
}

###################################################################
# Docker options
###################################################################
variable "docker_tag" {
  description = "Tag used for the docker image required."
  type        = string
  default     = "tf-jinja-renderer:latest"
}
