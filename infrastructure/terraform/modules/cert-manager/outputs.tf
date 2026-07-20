output "namespace" {

  value = kubernetes_namespace_v1.cert_manager.metadata[0].name

}

output "cluster_issuer" {

  value = var.issuer_name

}