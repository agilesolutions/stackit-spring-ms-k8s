variable "project_id" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "postgres_version" {
  type    = string
  default = "16"
}

variable "cpu" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 4096
}

variable "storage_size" {
  type    = number
  default = 20 # size in GB
}

variable "database_name" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "postgres_password" {
  default = "pwd"
}

