
terraform {
  required_providers {
    stackit = {
      source = "stackitcloud/stackit"
    }
  }
}

provider "stackit" {}

resource "stackit_kubernetes_cluster" "demo" {
  name = "gov-demo-v2"
}
