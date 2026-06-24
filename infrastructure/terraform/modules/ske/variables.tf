variable "project_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type    = string
  default = "eu01"
}

variable "kubernetes_version" {
  type    = string
  default = "1.30"
}

variable "machine_type" {
  type    = string
  default = "c1.2"
}

variable "node_pool_min" {
  type    = number
  default = 3
}

variable "node_pool_max" {
  type    = number
  default = 6
}

variable "availability_zones" {

  type = list(string)

  default = [
    "eu01-1",
    "eu01-2",
    "eu01-3"
  ]
}