resource "kubernetes_namespace" "monitoring" {

  metadata {
    name = var.namespace
  }

}

resource "helm_release" "prometheus" {

  name = "kube-prometheus-stack"

  namespace = var.namespace

  repository =
  "https://prometheus-community.github.io/helm-charts"

  chart = "kube-prometheus-stack"

  version = "72.6.3"

  values = [
    templatefile(
      "${path.module}/values.yaml.tpl",
      {}
    )
  ]

}