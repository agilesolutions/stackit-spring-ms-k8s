terraform {

  required_version = ">= 1.9"

  required_providers {

    stackit = {
      source  = "stackitcloud/stackit"
      version = "~> 0.54"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    helm = {
      source = "hashicorp/helm"
    }
  }
}