###############################################
# DNS Zone
###############################################
resource "stackit_dns_zone" "this" {
  project_id = var.project_id
  name     = var.zone_name
  dns_name = var.dns_name
  labels = merge(
    {
      managed-by = "terraform"
      module     = "dns"
    },
    var.labels
  )
}