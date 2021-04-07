output "rendered_template" {
  value       = docker_container.jinja_renderer.container_logs
  description = "Rendered template"
}
