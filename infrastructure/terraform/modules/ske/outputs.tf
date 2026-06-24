output "cluster_name" {

  value = stackit_ske_cluster.this.name

}

output "kubeconfig" {

  value     = stackit_ske_kubeconfig.this.kube_config

  sensitive = true

}

output "egress_address_ranges" {

  value = stackit_ske_cluster.this.egress_address_ranges

}

output "pod_address_ranges" {

  value = stackit_ske_cluster.this.pod_address_ranges

}