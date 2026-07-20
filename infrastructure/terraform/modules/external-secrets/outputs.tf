output "namespace" {
  value = kubernetes_namespace_v1.external_secrets.metadata[0].name
}

output "cluster_secret_store" {
  value = kubectl_manifest.cluster_secret_store.name
}