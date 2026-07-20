variable "namespace" {
  type    = string
  default = "unleash"
}

variable "chart_version" {
  type = string
}

variable "hostname" {
  type = string
}

variable "database_host" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_user" {
  type = string
}

variable "database_password" {
  type      = string
  sensitive = true
}

variable "service_type" {
  type    = string
  default = "ClusterIP"
}