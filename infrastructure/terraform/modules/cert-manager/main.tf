# Namespace
resource "kubernetes_namespace_v1" "cert_manager" {
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
    name  = "installCRDs"
    value = "true"
  }
}

# ClusterIssuer
resource "kubectl_manifest" "cert_manager_cluster_issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: var.issuer_name
spec:
  acme:
    server: var.acme_server
    email: var.email
    privateKeySecretRef:
      name: ${var.issuer_name}-account-key
    solvers:
    - http01:
        ingress:
          ingressClassName: nginx
YAML

  # Ensure cert-manager Helm chart finishes installing before creating the issuer
  depends_on = [helm_release.cert_manager]
}