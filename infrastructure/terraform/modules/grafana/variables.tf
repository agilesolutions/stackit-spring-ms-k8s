variable "namespace" {

  type = string

  default = "monitoring"

}

variable "hostname" {

  type = string

}

variable "admin_password" {

  type = string

  sensitive = true

}

variable "prometheus_url" {

  type = string

}

variable "loki_url" {

  type = string

}

variable "tempo_url" {

  type = string

}