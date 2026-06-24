output "namespace" {

  value = kubernetes_namespace.cert_manager.metadata[0].name

}

output "cluster_issuer" {

  value = var.issuer_name

}