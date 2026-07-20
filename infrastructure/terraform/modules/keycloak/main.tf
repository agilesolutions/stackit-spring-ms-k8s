resource "kubernetes_namespace_v1" "keycloak" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret_v1" "keycloak" {
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

  depends_on = [
    kubernetes_namespace_v1.keycloak
  ]
}

resource "helm_release" "keycloak" {
  name = "keycloak"
  namespace = var.namespace
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart = "keycloak"
  version = "24.3.1"

  set {
    name  = "image.repository"
    value = "bitnamilegacy/keycloak"
  }

  set {
    name  = "image.tag"
    value = "26.0.7-debian-12-r0"
  }

  values = [
    templatefile(
      "${path.module}/values.yaml.tpl",
      {
        postgres_enabled = var.postgres_enabled
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
    kubernetes_namespace_v1.keycloak
  ]
}

resource "kubectl_manifest" "certificate" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: keycloak
  namespace: ${var.namespace}
spec:
  secretName: keycloak-tls
  dnsNames:
  - ${var.hostname}
  issuerRef:
    name: letsencrypt
    kind: ClusterIssuer
YAML

  # Ensures Keycloak's chart/namespace is ready before declaring the cert manifest
  depends_on = [
    helm_release.keycloak
  ]
}


# 2. Query the Operator Deployment status directly from Kubernetes
data "kubernetes_resource" "keycloak_operator" {
  api_version = "v1"
  kind        = "Deployment"

  metadata {
    name      = "keycloak"
    namespace = var.namespace
  }

  depends_on = [
    helm_release.keycloak
  ]
}

