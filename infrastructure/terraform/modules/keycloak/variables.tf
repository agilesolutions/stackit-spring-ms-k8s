variable "namespace" {
  type = string
  default = "keycloak"
}

variable "hostname" {
  type = string
}

variable "postgres_host" {
  type = string
}

variable "postgres_database" {
  type = string
  default = "keycloak"
}

variable "postgres_username" {
  type = string
}

variable "postgres_password" {
  type = string
  sensitive = true
}

variable "keycloak_admin_user" {
  type = string
  default = "admin"
}

variable "keycloak_admin_password" {
  type = string
  sensitive = true
}