##############################################
# Grafana Alloy : Grafana’s officiele, open-source OpenTelemetry Collector + all backends and grafana
##############################################
module "alloy" {
  source = "../../modules/alloy"
  namespace = "monitoring"
  loki_url = var.loki_url
  tempo_endpoint = var.tempo_endpoint
  prometheus_remote_write_url = var.prometheus_remote_write_url

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
  flux_path = "fluxcd/bootstrap/local"
  create_repository = false
  deploy_key_read_only = false
}

provider "flux" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "docker-desktop"
  }

  git = {
    url = "ssh://git@github.com/agilesolutions/stackit-spring-ms-k8s.git"
    branch = "master"
    ssh = {
      username    = "git"
      # FIX: Grabs the key generated inside the module via its output parameter
      private_key = module.flux.private_key_pem
    }
  }
}
