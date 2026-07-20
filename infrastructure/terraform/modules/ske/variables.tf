variable "project_id" {
  type = string
}

variable "dns_name" {
  description = "DNS name for generated Zone"
  type        = string
}

variable "observability_instance_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type    = string
  default = "eu01"
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