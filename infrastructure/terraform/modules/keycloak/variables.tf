variable "namespace" {
  type = string
  default = "keycloak"
}

variable "hostname" {
  type = string
}

variable "postgres_enabled" {
  type = bool
  default = false
}

variable "postgres_host" {
  type = string
  default = "postgresql.postgresql.svc.cluster.local"
}

variable "postgres_database" {
  type = string
  default = "keycloak"
}

variable "postgres_username" {
  type = string
  default = "keycloak"
}

variable "postgres_password" {
  type = string
  sensitive = true
  default = "keycloak"
}

variable "keycloak_admin_user" {
  type = string
  default = "admin"
}

variable "keycloak_admin_password" {
  type = string
  sensitive = true
}