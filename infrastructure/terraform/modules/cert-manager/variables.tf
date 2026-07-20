variable "namespace" {

  type = string

  default = "cert-manager"

}

variable "email" {

  type = string

}

variable "issuer_name" {

  type = string

  default = "letsencrypt"

}

variable "acme_server" {

  type = string

  default = "https://acme-v02.api.letsencrypt.org/directory"

}