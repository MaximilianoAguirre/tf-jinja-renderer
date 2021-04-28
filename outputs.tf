output "rendered_template" {
  value       = data.external.container_outputs.result.rendered_template
  description = "Rendered template"
}
