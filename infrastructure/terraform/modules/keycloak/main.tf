resource "kubernetes_namespace" "keycloak" {

  metadata {

    name = var.namespace

  }

}

resource "kubernetes_secret" "keycloak" {

  metadata {

    name = "keycloak-secret"

    namespace = var.namespace

  }

  type = "Opaque"

  data = {

    admin-password = base64encode(
      var.keycloak_admin_password
    )

    postgres-password = base64encode(
      var.postgres_password
    )

  }

}

resource "helm_release" "keycloak" {

  name = "keycloak"

  namespace = var.namespace

  repository = "https://charts.bitnami.com/bitnami"

  chart = "keycloak"

  version = "24.4.11"

  values = [

    templatefile(
      "${path.module}/values.yaml.tpl",

      {

        hostname = var.hostname

        postgres_host = var.postgres_host

        postgres_database = var.postgres_database

        postgres_username = var.postgres_username

        postgres_password = var.postgres_password

        admin_user = var.keycloak_admin_user

        admin_password = var.keycloak_admin_password

      }

    )

  ]

  depends_on = [

    kubernetes_namespace.keycloak

  ]

}

resource "kubernetes_manifest" "certificate" {

  manifest = {

    apiVersion = "cert-manager.io/v1"

    kind = "Certificate"

    metadata = {

      name = "keycloak"

      namespace = var.namespace

    }

    spec = {

      secretName = "keycloak-tls"

      dnsNames = [

        var.hostname

      ]

      issuerRef = {

        name = "letsencrypt"

        kind = "ClusterIssuer"

      }

    }

  }

}

