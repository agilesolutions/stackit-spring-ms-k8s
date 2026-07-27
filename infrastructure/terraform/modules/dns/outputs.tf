###############################################
# DNS Zone outputs
###############################################
output "zone_id" {
  description = "STACKIT DNS zone ID"
  value = stackit_dns_zone.this.id
}

output "zone_name" {
  description = "Human readable DNS zone name"
  value = stackit_dns_zone.this.name
}

output "dns_name" {
  description = "DNS zone domain name"
  value = stackit_dns_zone.this.dns_name
}