data "external" "jinja_renderer" {
  program = ["/bin/bash", "${path.module}/jinja.sh"]

  query = {
    jinja_template    = var.jinja_template
    data              = var.data
    filters           = jsonencode(var.filters)
    module_directory  = abspath(path.module)
  }
}
