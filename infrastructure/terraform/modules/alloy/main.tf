resource "kubernetes_namespace" "monitoring" {

  metadata {

    name = var.namespace

  }

}

resource "kubernetes_config_map" "alloy" {

  metadata {

    name      = "alloy-config"

    namespace = var.namespace

  }

  data = {

    "config.alloy" = templatefile(
      "${path.module}/alloy.river.tpl",
      {
        loki_url                    = var.loki_url
        tempo_endpoint              = var.tempo_endpoint
        prometheus_remote_write_url = var.prometheus_remote_write_url
      }
    )

  }

}

resource "helm_release" "alloy" {

  name       = "alloy"

  namespace  = var.namespace

  repository = "https://grafana.github.io/helm-charts"

  chart      = "alloy"

  version    = var.chart_version

  values = [

    templatefile(
      "${path.module}/values.yaml.tpl",
      {
        namespace = var.namespace
      }
    )

  ]

  depends_on = [
    kubernetes_config_map.alloy
  ]

}