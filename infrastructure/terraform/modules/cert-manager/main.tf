# Namespace

resource "kubernetes_namespace" "cert_manager" {

  metadata {

    name = var.namespace

  }

}

# Helm installatie

resource "helm_release" "cert_manager" {

  name = "cert-manager"

  namespace = var.namespace

  repository = "https://charts.jetstack.io"

  chart = "cert-manager"

  version = "v1.18.2"

  create_namespace = false

  set {

    name = "crds.enabled"

    value = "true"

  }

}

# ClusterIssuer

resource "kubernetes_manifest" "cluster_issuer" {

  manifest = yamldecode(
    templatefile(
      "${path.module}/cluster-issuer.yaml.tpl",
      {
        issuer_name = var.issuer_name
        email       = var.email
        acme_server = var.acme_server
      }
    )
  )

  depends_on = [
    helm_release.cert_manager
  ]

}