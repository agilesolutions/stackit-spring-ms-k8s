resource "helm_release" "tempo" {

  name = "tempo"

  namespace = "monitoring"

  repository =
  "https://grafana.github.io/helm-charts"

  chart = "tempo"

  version = "1.23.2"

}