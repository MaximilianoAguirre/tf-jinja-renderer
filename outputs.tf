output "rendered_template" {
  value       = data.external.jinja_renderer.result.rendered_template
  description = "Rendered template"
}
