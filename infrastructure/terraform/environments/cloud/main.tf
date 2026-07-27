##############################################
# Grafana Alloy : Grafana’s officiele, open-source OpenTelemetry Collector + all backends and grafana
##############################################
module "o11y" {
  source = "../../modules/o11y"
  project_id = var.project_id

}

module "dns" {
  source = "../../modules/dns"

  project_id = var.project_id
  zone_name  = "Overheid Zone"
  dns_name   = var.dns_name
}


##############################################
# SKE CLUSTER
##############################################
module "ske" {
  source = "../../modules/ske"
  project_id = var.project_id
  observability_instance_id = module.o11y.observability_instance_id
  cluster_name = var.cluster_name
  dns_name = module.dns.dns_name
  node_pool_min = 3
  node_pool_max = 6

}

##############################################
# PostgreSQL
##############################################
module "postgres" {
  source = "../../modules/postgresql"
  project_id = var.project_id
  instance_name = "government-postgres"
  database_name = "vergunningdb"
  admin_username = var.postgres_user
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
# External Secrets Operator
##############################################
module "external_secrets" {
  source = "../../modules/external-secrets"
  vault_address = "http://vault.vault.svc.cluster.local:8200"
  vault_path = "secret"
  vault_role = "external-secrets"

  depends_on = [
    module.ske
  ]
}

##############################################
# FluxCD
##############################################
module "flux" {
  source = "../../modules/fluxcd"
  github_owner      = "agilesolutions"
  github_repository = "stackit-spring-ms-k8s"
  github_token = var.github_token
  cluster_name = "stackit-dev"
  flux_path = "fluxcd/bootstrap"
  create_repository = false
  deploy_key_read_only = false
  application_domain = module.dns.application_domain

  depends_on = [
    module.ske
  ]

}



##############################################
# Unleash: exposing feature flags to springboot configs
##############################################

module "unleash" {
  source = "../../modules/unleash"

  chart_version = "6.4.3"

  hostname = "unleash-dev.example.com"

  database_host     = module.postgres.postgres_dsn
  database_name     = "unleash"
  database_user     = var.postgres_user
  database_password = var.postgres_password

  depends_on = [module.postgres]

}