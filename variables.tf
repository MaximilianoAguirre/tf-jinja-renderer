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

variable "docker_tag" {
  description = "Tag used for the docker image required."
  type        = string
  default     = "jinja:latest"
}
