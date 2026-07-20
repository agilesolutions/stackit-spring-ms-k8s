output "instance_id" {
  value = stackit_postgresflex_instance.overheid.instance_id
}

# Output the complete connection string (Marked sensitive due to the password)
output "postgres_dsn" {
  value = format(
    "postgres://%s:%s@%s:%d/%s",
    stackit_postgresflex_user.application.username,
    stackit_postgresflex_user.application.password,
    stackit_postgresflex_user.application.host,
    stackit_postgresflex_user.application.port,
    stackit_postgresflex_database.application.name
  )
  sensitive = true
}