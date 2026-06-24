output "instance_id" {

  value = stackit_postgresflex_instance.overheid.instance_id

}

# Output the host address
output "postgres_host" {
  value       = stackit_postgresflex_user.application.host
  description = "The database cluster endpoint address."
}

# Output the port number
output "postgres_port" {
  value       = stackit_postgresflex_user.application.port
  description = "The port number for database connections."
}

output "database_name" {

  value = stackit_postgresflex_database.application.name

}

output "username" {

  value = stackit_postgresflex_user.application.username

}

# Output the complete connection string (Marked sensitive due to the password)
output "postgres_connection_uri" {
  value       = stackit_postgresflex_user.application.uri
  sensitive   = true
  description = "The full PostgreSQL connection URI string."
}

}