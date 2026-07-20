resource "stackit_observability_instance" "overheid" {
  project_id                             = var.project_id
  name                                   = "overheid"
  # Observability-Starter-EU01 may be enough for a short trial, but the metric samples (per minute) limit is quickly reached with our example.
  plan_name                              = "Observability-Basic-EU01"
}

resource "stackit_observability_credential" "cluster" {
  project_id  = var.project_id
  instance_id = stackit_observability_instance.overheid.id
}