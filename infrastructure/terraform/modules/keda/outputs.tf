output "release_name" {
  description = "KEDA Helm release name."
  value       = helm_release.keda.name
}

output "namespace" {
  description = "Namespace where KEDA is installed."
  value       = helm_release.keda.namespace
}

output "chart_version" {
  description = "Installed KEDA chart version."
  value       = helm_release.keda.version
}

output "status" {
  description = "Helm release status."
  value       = helm_release.keda.status
}