output "url" {
  value = "https://${var.hostname}"
}

output "realm_url" {
  value = "https://${var.hostname}/realms/overheid"
}

output "token_endpoint" {
  value = "https://${var.hostname}/realms/overheid/protocol/openid-connect/token"
}

output "issuer_uri" {
  value = "https://${var.hostname}/realms/overheid"
}

# Outputs the DESIRED replicas configured in the spec
output "desired_replicas" {
  value       = data.kubernetes_resource.keycloak_operator.object.status[0].replicas
  description = "The number of replicas defined in the deployment configuration."
}

# Outputs the ACTUAL ready replicas running right now
output "ready_replicas" {
  value       = data.kubernetes_resource.keycloak_operator.object.status[0].readyReplicas
  description = "The number of pods that are actively running and ready."
}