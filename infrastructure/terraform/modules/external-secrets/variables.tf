variable "namespace" {

  type = string

  default = "external-secrets"

}

variable "vault_address" {

  type = string

}

variable "vault_path" {

  type = string

  default = "secret"

}

variable "vault_role" {

  type = string

  default = "external-secrets"

}