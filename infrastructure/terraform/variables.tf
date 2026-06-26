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

variable "postgres_password" {
  default = "postgres"
}

variable "keycloak_db_password" {
  default = "admin"
}

variable "keycloak_admin_password" {
  default = "admin"
}

variable "github_token" {
  default = "tbs"
}

variable "grafana_admin_password" {
  default = "admin"
}
