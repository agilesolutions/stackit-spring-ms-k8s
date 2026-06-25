resource "helm_release" "otel" {

  name = "opentelemetry"

  namespace = "monitoring"

  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"

  chart = "opentelemetry-collector"

  version = "0.128.0"

  values = [
    templatefile(
      "${path.module}/values.yaml.tpl",
      {}
    )
  ]

}