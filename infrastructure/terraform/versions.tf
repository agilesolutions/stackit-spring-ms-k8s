terraform {

  required_version = ">= 1.9"

  required_providers {

    stackit = {
      source  = "stackitcloud/stackit"
      version = "~> 0.99" # Use the latest stable version
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.32"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~> 2.14"
    }
  }
}
