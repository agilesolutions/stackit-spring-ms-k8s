variable "name" {
  description = "Helm release name."
  type        = string
  default     = "keda"
}

variable "namespace" {
  description = "Kubernetes namespace where KEDA is installed."
  type        = string
  default     = "keda"
}

variable "create_namespace" {
  description = "Create the namespace if it does not exist."
  type        = bool
  default     = true
}

variable "repository" {
  description = "KEDA Helm repository."
  type        = string
  default     = "https://kedacore.github.io/charts"
}

variable "chart" {
  description = "KEDA Helm chart name."
  type        = string
  default     = "keda"
}

variable "chart_version" {
  description = "KEDA Helm chart version."
  type        = string
}

variable "atomic" {
  description = "Rollback the release if installation fails."
  type        = bool
  default     = true
}

variable "cleanup_on_fail" {
  description = "Clean up failed resources."
  type        = bool
  default     = true
}

variable "wait" {
  description = "Wait until resources are ready."
  type        = bool
  default     = true
}

variable "timeout" {
  description = "Timeout in seconds for Helm operations."
  type        = number
  default     = 600
}

variable "values" {
  description = "Additional Helm values files/content."
  type        = list(string)
  default     = []
}

variable "set_values" {
  description = "Additional Helm values set using key/value pairs."
  type        = map(string)
  default     = {}
}