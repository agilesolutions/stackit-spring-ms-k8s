variable "namespace" {

  type = string

  default = "ingress-nginx"

}

variable "replica_count" {

  type = number

  default = 2

}

variable "enable_metrics" {

  type = bool

  default = true

}

variable "enable_modsecurity" {

  type = bool

  default = false

}