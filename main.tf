data "external" "jinja_renderer" {
  program = ["/bin/bash", "${path.module}/jinja.sh"]

  query = {
    working_directory = abspath(var.working_directory)
    jinja_template    = var.jinja_template
    data              = var.data
    filters           = jsonencode(var.filters)
    module_directory  = path.module
  }
}
