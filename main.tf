data "external" "jinja_renderer" {
  program = ["/bin/bash", "${path.module}/jinja.sh"]

  query = {
    jinja_template   = var.jinja_template
    data             = var.data
    filters          = jsonencode(var.filters)
    module_directory = abspath(path.module)
    docker_tag       = var.docker_tag
    allow_undefined  = var.allow_undefined
    data_format      = var.data_format
  }
}
