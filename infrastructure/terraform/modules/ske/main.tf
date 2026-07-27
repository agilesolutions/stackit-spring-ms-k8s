data "stackit_ske_kubernetes_versions" "supported" {
  version_state = "SUPPORTED"
}

resource "stackit_ske_cluster" "overheid" {
  project_id             = var.project_id
  region = var.region
  name = var.cluster_name
  kubernetes_version_min = data.stackit_ske_kubernetes_versions.supported.kubernetes_versions.0.version
  node_pools = [
    {
      name               = "system"
      machine_type       = "c2i.4"
      os_name            = "flatcar"
      machine_type = var.machine_type
      minimum = var.node_pool_min
      maximum = var.node_pool_max
      availability_zones = var.availability_zones
      volume_type        = "storage_premium_perf2"
      cri = "containerd"
      allow_system_components = true
      labels = {
        nodepool = "system"
        workload = "platform"
      }

    }
  ]
  maintenance = {
    enable_kubernetes_version_updates    = true
    enable_machine_image_version_updates = true
    start                                = "01:00:00Z"
    end                                  = "02:00:00Z"
  }
  extensions = {
    dns = {
      enabled = true
      zones   = [var.dns_name]
    }
    observability = {
      instance_id = var.observability_instance_id
      enabled           = true
    }
  }
}

resource "stackit_ske_kubeconfig" "overheid" {
  project_id = var.project_id
  cluster_name = stackit_ske_cluster.overheid.name
  refresh = true
  expiration = 7200
  refresh_before = 3600
}

# 1. Fetch details of an existing STACKIT Kubernetes Engine (SKE) cluster
data "stackit_ske_cluster" "overheid_cluster" {
  project_id = stackit_ske_cluster.overheid.project_id
  name       = stackit_ske_cluster.overheid.name

  depends_on = [stackit_ske_cluster.overheid] # Ensure this data source is evaluated after the cluster is created

}

output "ske_nodepool_taints_map" {
  description = "A scannable map of node pool names paired with their assigned taints."
  value = {
    for pool in data.stackit_ske_cluster.overheid_cluster.node_pools :
    pool.name => [
      for t in coalesce(pool.taints, []) : {
        key    = t.key
        value  = t.value
        effect = t.effect
      }
    ]
  }

  depends_on = [data.stackit_ske_cluster.overheid_cluster] # Ensure this output is evaluated after the cluster data is fetched
}
