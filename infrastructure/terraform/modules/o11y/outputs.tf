output "observability_instance_id" {
  value = stackit_observability_instance.overheid.id
}

output "grafana_url" {
  value = stackit_observability_instance.overheid.grafana_url
}

output "logs_push_url" {
  value = stackit_observability_instance.overheid.logs_push_url
}

output "metrics_push_url" {
  value = stackit_observability_instance.overheid.metrics_push_url
}

output "cluster_user" {
  value = stackit_observability_credential.cluster.username
}

output "cluster_password" {
  value = stackit_observability_credential.cluster.password
  sensitive = true
}

output "prometheus_metrics_url" {
  description = "STACKIT Observability Prometheus metrics/query URL."
  value       = stackit_observability_instance.overheid.metrics_url
}