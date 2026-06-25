# namespace

resource "kubernetes_namespace" "monitoring" {

  metadata {

    name = var.namespace

  }

}

# Grafana Helm Release

resource "helm_release" "grafana" {

  name = "grafana"

  namespace = var.namespace

  repository = "https://grafana.github.io/helm-charts"

  chart = "grafana"

  version = "9.2.10"

  values = [

    templatefile(
      "${path.module}/values.yaml.tpl",
      {
        hostname       = var.hostname
        admin_password = var.admin_password
        prometheus_url = var.prometheus_url
        loki_url       = var.loki_url
        tempo_url      = var.tempo_url
      }
    )

  ]

}

# Spring Boot Dashboard

resource "kubernetes_config_map" "spring_dashboard" {

  metadata {

    name = "springboot-dashboard"

    namespace = var.namespace

    labels = {

      grafana_dashboard = "1"

    }

  }

  data = {

    "springboot.json" = file("${path.module}/dashboards/springboot.json")

  }

}

# Kubernetes Dashboard

resource "kubernetes_config_map" "kubernetes_dashboard" {

  metadata {

    name = "kubernetes-dashboard"

    namespace = var.namespace

    labels = {

      grafana_dashboard = "1"

    }

  }

  data = {

    "kubernetes.json" = file("${path.module}/dashboards/kubernetes.json")

  }

}

# PostgreSQL Dashboard

resource "kubernetes_config_map" "postgres_dashboard" {

  metadata {

    name = "postgres-dashboard"

    namespace = var.namespace

    labels = {

      grafana_dashboard = "1"

    }

  }

  data = {

    "postgres.json" = file("${path.module}/dashboards/postgres.json")

  }

}

