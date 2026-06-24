resource "stackit_ske_cluster" "this" {

  project_id = var.project_id

  region = var.region

  name = var.cluster_name

  kubernetes_version_min = var.kubernetes_version

  node_pools = [

    {

      name = "system"

      machine_type = var.machine_type

      minimum = var.node_pool_min

      maximum = var.node_pool_max

      availability_zones = var.availability_zones

      volume_size = 100

      volume_type = "storage_premium_perf6"

      cri = "containerd"

      allow_system_components = true

      labels = {

        nodepool = "system"

        workload = "platform"

      }

    }

  ]

  maintenance = {

    enable_kubernetes_version_updates = true

    enable_machine_image_version_updates = true

    start = "01:00:00Z"

    end = "03:00:00Z"

  }

  network = {

    control_plane = {

      access_scope = "PUBLIC"

    }

  }

}

resource "stackit_ske_kubeconfig" "this" {

  project_id = var.project_id

  cluster_name = stackit_ske_cluster.this.name

  refresh = true

  expiration = 7200

  refresh_before = 3600

}