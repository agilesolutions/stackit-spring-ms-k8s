output "namespace" {

  value = kubernetes_namespace.ingress.metadata[0].name

}

output "ingress_class" {

  value = "nginx"

}