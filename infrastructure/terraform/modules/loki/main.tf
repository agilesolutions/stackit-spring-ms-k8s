resource "helm_release" "loki" {

  name = "loki"

  namespace = var.namespace

  repository = "https://grafana.github.io/helm-charts"

  chart = "loki"

  version = "6.31.0"

}

# Promtail

resource "helm_release" "promtail" {

  name = "promtail"

  namespace = var.namespace

  repository = "https://grafana.github.io/helm-charts"

  chart = "promtail"

}

