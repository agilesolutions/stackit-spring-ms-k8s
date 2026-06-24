variable "namespace" {

  type = string

  default = "flux-system"

}

variable "git_repository" {

  type = string

}

variable "git_branch" {

  type = string

  default = "main"

}

variable "git_path" {

  type = string

  default = "clusters/dev"

}

variable "github_token" {

  type = string

  sensitive = true

}