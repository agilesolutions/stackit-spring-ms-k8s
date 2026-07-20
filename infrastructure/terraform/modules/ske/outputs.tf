output "repository_name" {
  description = "GitOps repository name."
  value       = var.github_repository
}

output "repository_url" {
  description = "GitOps repository URL."
  value       = "https://github.com/${var.github_owner}/${var.github_repository}"
}

output "flux_namespace" {
  description = "Flux namespace."
  value       = flux_bootstrap_git.this.namespace
}

output "flux_path" {
  description = "Flux reconciliation path."
  value       = flux_bootstrap_git.this.path
}

output "flux_version" {
  description = "Installed Flux version."
  value       = flux_bootstrap_git.this.version
}

output "deploy_key_id" {
  description = "GitHub deploy key ID."
  value       = github_repository_deploy_key.flux.id
}

output "flux_private_key" {
  description = "Flux SSH private key."
  value       = tls_private_key.flux.private_key_openssh
  sensitive   = true
}