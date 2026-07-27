variable "project_id" {
  description = "STACKIT project ID where the DNS zone is created"
  type = string
}

variable "dns_name" {
  description = <<EOF
DNS domain name of the zone.
Example:
overheid.example.nl
EOF
  type = string
}

variable "zone_name" {
  description = "Human readable name of the DNS zone"
  type = string
  default = "Kubernetes Platform DNS Zone"
}

variable "labels" {
  description = "Additional labels/tags for the DNS zone"
  type = map(string)
  default = {}
}