# namespace

resource "kubernetes_namespace" "ingress" {

  metadata {

    name = var.namespace

  }

}

# helm release

resource "helm_release" "ingress_nginx" {

  name = "ingress-nginx"

  namespace = var.namespace

  repository = "https://kubernetes.github.io/ingress-nginx"

  chart = "ingress-nginx"

  version = "4.12.3"

  values = [

    templatefile(
      "${path.module}/values.yaml.tpl",
      {
        replica_count     = var.replica_count
        enable_metrics    = var.enable_metrics
        enable_modsecurity = var.enable_modsecurity
      }
    )

  ]

}

# service monitor CRD

resource "kubernetes_manifest" "servicemonitor" {

  manifest = {

    apiVersion = "monitoring.coreos.com/v1"

    kind = "ServiceMonitor"

    metadata = {

      name = "ingress-nginx"

      namespace = var.namespace

    }

    spec = {

      selector = {

        matchLabels = {

          "app.kubernetes.io/name" = "ingress-nginx"

        }

      }

      endpoints = [

        {

          port = "metrics"

          interval = "30s"

        }

      ]

    }

  }

}

