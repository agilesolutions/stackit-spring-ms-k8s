##############################################
# KEDA - Scale dynamically based on metrics like Kafka lag, or webhook traffic, and critically, it enables scaling down to zero replicas when idle to completely eliminate infrastructure costs.
##############################################

resource "helm_release" "keda" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = var.create_namespace

  repository = var.repository
  chart      = var.chart
  version    = var.chart_version

  atomic          = var.atomic
  cleanup_on_fail = var.cleanup_on_fail
  wait            = var.wait
  timeout         = var.timeout

  values = var.values

  dynamic "set" {
    for_each = var.set_values

    content {
      name  = set.key
      value = set.value
    }
  }
}