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
provider "stackit" {
  service_account_key_path = "${path.module}/sa-key.json"
  default_region           = var.region
}

##############################################
# SKE CLUSTER
##############################################

module "ske" {

  source = "./modules/ske"

  project_id = var.project_id

  cluster_name = var.cluster_name

  kubernetes_version = "1.30"

  node_pool_min = 3

  node_pool_max = 6

}
##############################################
# Kubernetes Provider
##############################################

provider "kubernetes" {
# Extract host, CA, and client auth data from the kube_config
  host = yamldecode(module.ske.kubeconfig).clusters[0].cluster.server

  cluster_ca_certificate = base64decode(yamldecode(module.ske.kubeconfig).clusters[0].cluster.certificate-authority-data)
  client_certificate     = base64decode(yamldecode(module.ske.kubeconfig).users[0].user.client-certificate-data)
  client_key             = base64decode(yamldecode(module.ske.kubeconfig).users[0].user.client-key-data)
}



##############################################
# Helm Provider
##############################################

provider "helm" {

  kubernetes {

    host = yamldecode(module.ske.kubeconfig).clusters[0].cluster.server

    cluster_ca_certificate = base64decode(yamldecode(module.ske.kubeconfig).clusters[0].cluster.certificate-authority-data)
    client_certificate     = base64decode(yamldecode(module.ske.kubeconfig).users[0].user.client-certificate-data)
    client_key             = base64decode(yamldecode(module.ske.kubeconfig).users[0].user.client-key-data)

  }
}

##############################################
# PostgreSQL
##############################################


module "postgres" {

  source = "./modules/postgresql"

  project_id = var.project_id

  instance_name = "government-postgres"

  database_name = "vergunningdb"

  admin_username = "vergunning"

  admin_password = var.postgres_password

  postgres_version = "16"

  cpu = 2

  memory = 4096

  storage_size = 100

  depends_on = [
    module.ske
  ]

}

##############################################
# Ingress NGINX
##############################################

module "ingress_nginx" {

  source = "./modules/ingress-nginx"

  replica_count = 2

  enable_metrics = true

  enable_modsecurity = true

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

  depends_on = [
    module.ske
  ]

}
##############################################
# External Secrets Operator
##############################################

module "external_secrets" {

  source = "./modules/external-secrets"

  vault_address = "http://vault.vault.svc.cluster.local:8200"

  vault_path = "secret"

  vault_role = "external-secrets"

  depends_on = [
    module.ske
  ]

}
##############################################
# Keycloak
##############################################


module "keycloak" {

  source = "./modules/keycloak"

  hostname = "keycloak.platform.example.nl"

  postgres_host = module.postgres.postgres_host

  postgres_database = "keycloak"

  postgres_username = "keycloak"

  postgres_password = var.keycloak_db_password

  keycloak_admin_user = "admin"

  keycloak_admin_password = var.keycloak_admin_password

  depends_on = [
    module.ske
  ]

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

  depends_on = [
    module.ske
  ]

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


##############################################
# Grafana
##############################################

module "grafana" {

  source = "./modules/grafana"

  hostname = "grafana.platform.example.nl"

  admin_password = var.grafana_admin_password

  prometheus_url = "http://kube-prometheus-stack-prometheus.monitoring.svc.cluster.local"

  loki_url = "http://loki-gateway.monitoring.svc.cluster.local"

  tempo_url = "http://tempo.monitoring.svc.cluster.local:3100"

  depends_on = [
    module.ske
  ]

}
