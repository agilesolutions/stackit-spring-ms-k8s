resource "stackit_postgresflex_instance" "overheid" {

  project_id = var.project_id

  name = var.instance_name

  version = var.postgres_version

  replicas        = 3 # 1 for single mode, 3 for high-availability replication

  storage = {
    class = "premium-perf2-stackit"
    size  = 5
  }

  # Define hardware resources
  flavor = {
    cpu = var.cpu
    ram = var.memory
  }

  # The Access Control List configuration
  acl = [
    "193.148.160.0/19",                    # Trusted corporate subnet block
    "45.129.40.0/21",                     # Additional trusted range
    "93.229.84.137/32",                   # A specific single administrator IP
  ]


  backup_schedule = "00 02 * * *" # Daily backup at 2:00 AM (Cron format)

}

resource "stackit_postgresflex_database" "application" {

  project_id = var.project_id

  instance_id = stackit_postgresflex_instance.overheid.instance_id

  name = var.database_name

  owner       = var.admin_username

}

resource "stackit_postgresflex_user" "application" {

  project_id = var.project_id

  instance_id = stackit_postgresflex_instance.overheid.instance_id

  username = var.admin_username

  roles       = ["user", "admin"]

}