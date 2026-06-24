resource "stackit_postgresflex_instance" "overheid" {

  project_id = var.project_id

  name = var.instance_name

  version = var.postgres_version

  replicas        = 3 # 1 for single mode, 3 for high-availability replication

  # Define hardware resources
  flavor = {
    cpu = var.cpu
    ram = var.memory
  }

  storage {
    class = "premium-perf2-stackit"
    size = var.storage_size
  }

  backup_schedule = "00 02 * * *" # Daily backup at 2:00 AM (Cron format)

}

resource "stackit_postgresflex_database" "application" {

  project_id = var.project_id

  instance_id = stackit_postgresflex_instance.overheid.instance_id

  database_name = var.database_name

  owner       = var.admin_username

}

resource "stackit_postgresflex_user" "application" {

  project_id = var.project_id

  instance_id = stackit_postgresflex_instance.overheid.instance_id

  username = var.admin_username

  password = var.admin_password

}