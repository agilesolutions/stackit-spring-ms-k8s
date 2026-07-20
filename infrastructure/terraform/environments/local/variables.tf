variable "environment" {
  default = "dev"
}

variable "cluster_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "git_repository" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.30"
}
variable "region" {
  default = "eu01"
}

variable "postgres_user" {
  default = "admin"
}

variable "postgres_password" {
  default = "admin"
}

variable "keycloak_db_password" {
  default = "admin"
}

variable "keycloak_admin_password" {
  default = "admin"
}

variable "github_token" {
  default = "xxx"
}

variable "github_owner" {
  default = "tbs"
}

variable "grafana_admin_password" {
  default = "admin"
}


variable "loki_url" {
  type = string
}

variable "tempo_endpoint" {
  type = string
}

variable "prometheus_remote_write_url" {
  type = string
}

