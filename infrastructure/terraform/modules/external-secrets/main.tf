resource "kubernetes_namespace" "external_secrets" {

  metadata {

    name = var.namespace

  }

}

resource "helm_release" "external_secrets" {

  name = "external-secrets"

  namespace = kubernetes_namespace.external_secrets.metadata[0].name

  create_namespace = false

  repository = "https://charts.external-secrets.io"

  chart = "external-secrets"

  version = "0.15.0"

}

resource "kubernetes_manifest" "cluster_secret_store" {

  manifest = {

    apiVersion = "external-secrets.io/v1beta1"

    kind = "ClusterSecretStore"

    metadata = {

      name = "vault"

    }

    spec = {

      provider = {

        vault = {

          server = var.vault_address

          path = var.vault_path

          version = "v2"

          auth = {

            kubernetes = {

              mountPath = "kubernetes"

              role = var.vault_role

            }

          }

        }

      }

    }

  }

  depends_on = [
    helm_release.external_secrets
  ]

}

resource "kubernetes_manifest" "vergunning_service_secret" {

  manifest = {

    apiVersion = "external-secrets.io/v1beta1"

    kind = "ExternalSecret"

    metadata = {

      name = "vergunning-service"

      namespace = "applications"

    }

    spec = {

      refreshInterval = "1h"

      secretStoreRef = {

        name = "vault"

        kind = "ClusterSecretStore"

      }

      target = {

        name = "vergunning-service-secret"

      }

      data = [

        {

          secretKey = "DB_PASSWORD"

          remoteRef = {

            key = "vergunning-service"

            property = "db-password"

          }

        },

        {

          secretKey = "CLIENT_SECRET"

          remoteRef = {

            key = "vergunning-service"

            property = "oidc-secret"

          }

        }

      ]

    }

  }

  depends_on = [
    kubernetes_manifest.cluster_secret_store
  ]

}

resource "kubernetes_manifest" "zaken_service_secret" {

  manifest = {

    apiVersion = "external-secrets.io/v1beta1"

    kind = "ExternalSecret"

    metadata = {

      name = "zakenregistratie-service"

      namespace = "applications"

    }

    spec = {

      refreshInterval = "1h"

      secretStoreRef = {

        name = "vault"

        kind = "ClusterSecretStore"

      }

      target = {

        name = "zakenregistratie-service-secret"

      }

      data = [

        {

          secretKey = "DB_PASSWORD"

          remoteRef = {

            key = "zakenregistratie-service"

            property = "db-password"

          }

        }

      ]

    }

  }

}

