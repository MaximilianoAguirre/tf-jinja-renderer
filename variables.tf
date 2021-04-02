variable "working_directory" {
  description = "Directory containing templates and filters"
  type        = string
}

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
