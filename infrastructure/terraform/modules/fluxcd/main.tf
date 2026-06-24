resource "kubernetes_namespace" "flux" {

  metadata {

    name = var.namespace

  }

}

# FluxCD installatie

resource "helm_release" "flux" {

  name = "flux2"

  namespace = var.namespace

  repository = "https://fluxcd-community.github.io/helm-charts"

  chart = "flux2"

  version = "2.13.0"

  create_namespace = false

}

# Git Repository Secret

resource "kubernetes_secret" "github" {

  metadata {

    name = "flux-system"

    namespace = var.namespace

  }

  type = "Opaque"

  data = {

    username = base64encode("git")

    password = base64encode(var.github_token)

  }

}

# GitRepository Resource

resource "kubernetes_manifest" "git_repository" {

  manifest = {

    apiVersion = "source.toolkit.fluxcd.io/v1"

    kind = "GitRepository"

    metadata = {

      name = "platform"

      namespace = var.namespace

    }

    spec = {

      interval = "1m"

      url = var.git_repository

      ref = {

        branch = var.git_branch

      }

      secretRef = {

        name = "flux-system"

      }

    }

  }

  depends_on = [

    helm_release.flux

  ]

}

# Kustomization

resource "kubernetes_manifest" "platform" {

  manifest = {

    apiVersion = "kustomize.toolkit.fluxcd.io/v1"

    kind = "Kustomization"

    metadata = {

      name = "platform"

      namespace = var.namespace

    }

    spec = {

      interval = "5m"

      path = "./${var.git_path}"

      prune = true

      sourceRef = {

        kind = "GitRepository"

        name = "platform"

      }

      wait = true

      timeout = "5m"

    }

  }

  depends_on = [

    kubernetes_manifest.git_repository

  ]

}

