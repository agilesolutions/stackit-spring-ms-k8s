resource "helm_release" "this" {

  name             = "unleash"
  namespace        = var.namespace
  create_namespace = true

  repository = "https://docs.getunleash.io/helm-charts"
  chart      = "unleash"

  version = var.chart_version

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      hostname          = var.hostname
      database_host     = var.database_host
      database_name     = var.database_name
      database_user     = var.database_user
      database_password = var.database_password
      service_type      = var.service_type
    })
  ]

  wait    = true
  timeout = 600
}