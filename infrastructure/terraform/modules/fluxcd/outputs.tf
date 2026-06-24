output "namespace" {

  value = kubernetes_namespace.flux.metadata[0].name

}

output "git_repository" {

  value = var.git_repository

}