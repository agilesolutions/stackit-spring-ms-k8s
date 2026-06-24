output "url" {

  value = "https://${var.hostname}"

}

output "realm_url" {

  value = "https://${var.hostname}/realms/overheid"

}

output "token_endpoint" {

  value = "https://${var.hostname}/realms/overheid/protocol/openid-connect/token"

}

output "issuer_uri" {

  value = "https://${var.hostname}/realms/overheid"

}