terraform {

  required_version = ">= 1.9"

  required_providers {

    stackit = {
      source  = "stackitcloud/stackit"
      version = "~> 0.99" # Use the latest stable 0.x version
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 3.2"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~> 2.14"
    }

    external = {
      source = "hashicorp/external"
      version = ">= 2.0"
    }

    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.8"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }

  }
}

# Setting up Credentials...
# stackit auth login
# STACKIT CLI automatically merges the new cluster, user, and context entry directly into your local ~/.kube/config
# stackit ske kubeconfig create --project-id "$STACKIT_PROJECT_ID" "$CLUSTER_NAME" --login
# kubectl config use-context "$CLUSTER_NAME"
# Terraform provider using a sa-key.json file, using the Key Flow authentication mechanism
# stackit service-account key create --email <YOUR_SERVICE_ACCOUNT_EMAIL> --output-format json > sa-key.json
provider "stackit" {
  service_account_key_path = "${path.module}/sa-key.json"
  default_region           = var.region

  # Only include if using a separate, user-provided RSA private key file
  # private_key_path       = "/absolute/path/to/private_key.pem"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop" # Change this if using minikube or kind
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "docker-desktop" # Change this if using minikube or kind
  }
}

# 1. Bind Flux directly to your dynamically authorized SKE Cluster
provider "flux" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "docker-desktop"
  }
}

# 2. Configure GitHub Provider for repository access management
provider "github" {
  token = var.github_token
  owner = var.github_owner

}
