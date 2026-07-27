terraform {

  required_version = ">= 1.9"

  required_providers {

    stackit = {
      source  = "stackitcloud/stackit"
      version = "~> 0.99" # Use the latest stable 0.x version
    }

  }
}