resource "docker_image" "jinja_renderer" {
  name         = var.docker_image_tag
  keep_locally = true
}

locals {
  # Flags
  undefined = var.allow_undefined ? ["--undefined"] : [""]
  filters   = length(var.filters) != 0 ? concat(["--filters"], [for path in var.filters : basename(path)]) : [""]
  format    = ["--format", var.data_format]

  # Creating command to run
  flags   = compact(concat(local.undefined, local.filters, local.format))
  command = concat(["template", "data.${var.data_format}"], local.flags)
}

resource "random_string" "container_suffix" {
  length  = 6
  special = false
}

resource "docker_container" "jinja_renderer" {
  name        = "${var.docker_container_name}-${random_string.container_suffix.result}"
  image       = docker_image.jinja_renderer.latest
  working_dir = "/app"
  attach      = true
  logs        = true
  must_run    = false
  command     = local.command

  upload {
    content = var.jinja_template
    file    = "/app/template"
  }

  upload {
    content = var.data
    file    = "/app/data.${var.data_format}"
  }

  dynamic upload {
    for_each = [for path in var.filters : { path = path }]
    content {
      source      = upload.value["path"]
      source_hash = md5(file(upload.value["path"]))
      file        = "/app/${basename(upload.value["path"])}"
    }
  }
}
