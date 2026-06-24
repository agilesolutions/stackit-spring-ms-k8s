output "namespace" {

  value = kubernetes_namespace.external_secrets.metadata[0].name

}

output "cluster_secret_store" {

  value = kubernetes_manifest.cluster_secret_store.manifest.metadata.name

}