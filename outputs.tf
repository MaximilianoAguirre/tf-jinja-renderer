output "rendered_template" {
  value       = data.external.jinja_rendered.results.rendered_template
  description = "Rendered template"
}
