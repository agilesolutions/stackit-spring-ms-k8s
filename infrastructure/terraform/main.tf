##############################################
# STACKIT Government Reference Platform
#
# Components
#
# - SKE Kubernetes Cluster
# - PostgreSQL
# - FluxCD
# - External Secrets Operator
# - Keycloak
# - Ingress NGINX
# - Cert Manager
# - Prometheus/Grafana
#
##############################################

terraform {

  required_version = ">= 1.9"

  required_providers {

    stackit = {
      source  = "stackitcloud/stackit"
      version = "~> 0.98.0" # Use the latest stable version
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

##############################################
# SKE CLUSTER
##############################################

module "ske" {

  source = "./modules/ske"

  project_id = var.project_id

  cluster_name = "government-platform"

  kubernetes_version = "1.30"

  node_pool_min = 3

  node_pool_max = 6

}
##############################################
# Kubernetes Provider
##############################################

provider "kubernetes" {

  host                   = module.ske.host

  cluster_ca_certificate = base64decode(
    module.ske.cluster_ca_certificate
  )

  token = module.ske.token
}

##############################################
# Helm Provider
##############################################

provider "helm" {

  kubernetes {

    host                   = modules.ske.host

    cluster_ca_certificate = base64decode(
      module.ske.cluster_ca_certificate
    )

    token = module.ske.token
  }
}

##############################################
# PostgreSQL
##############################################


module "postgres" {

  source = "./modules/postgres"

  project_id = var.project_id

  instance_name = "government-postgres"

  database_name = "vergunningdb"

  admin_username = "vergunning"

  admin_password = var.postgres_password

  postgres_version = "16"

  cpu = 2

  memory = 4096

  storage_size = 100

}

##############################################
# Ingress NGINX
##############################################

module "ingress_nginx" {

  source = "./modules/ingress-nginx"

  depends_on = [
    module.ske
  ]
}

##############################################
# Cert Manager
##############################################

module "cert_manager" {

  source = "./modules/cert-manager"

  email = "robert.rong@agile-solutions.ch"

}
##############################################
# External Secrets Operator
##############################################

module "external_secrets" {

  source = "./modules/external-secrets"

  vault_address = "http://vault.vault.svc.cluster.local:8200"

  vault_path = "secret"

  vault_role = "external-secrets"

}
##############################################
# Keycloak
##############################################


module "keycloak" {

  source = "./modules/keycloak"

  hostname = "keycloak.platform.example.nl"

  postgres_host = module.postgres.host

  postgres_database = "keycloak"

  postgres_username = "keycloak"

  postgres_password = var.keycloak_db_password

  keycloak_admin_user = "admin"

  keycloak_admin_password = var.keycloak_admin_password

}

##############################################
# FluxCD
##############################################

module "fluxcd" {

  source = "./modules/fluxcd"

  git_repository = "https://github.com/agilesolutions/stackit-spring-ms-k8s.git"

  git_branch = "main"

  git_path = "clusters/dev"

  github_token = var.github_token

}
##############################################
# Monitoring
##############################################

module "monitoring" {

  source = "./modules/kube-prometheus-stack"

  depends_on = [
    module.ske
  ]
}

##############################################
# Loki
##############################################

module "loki" {

  source = "./modules/loki"

  depends_on = [
    module.ske
  ]
}

##############################################
# Tempo
##############################################

module "tempo" {

  source = "./modules/tempo"

  depends_on = [
    module.ske
  ]
}

##############################################
# OpenTelemetry
##############################################

module "otel_collector" {

  source = "./modules/opentelemetry"

  depends_on = [
    module.ske
  ]
}