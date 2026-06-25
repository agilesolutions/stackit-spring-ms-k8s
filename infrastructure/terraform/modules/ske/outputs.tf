output "cluster_name" {

  value = stackit_ske_cluster.overheid.name

}

output "kubeconfig" {

  value     = stackit_ske_kubeconfig.overheid.kube_config

  sensitive = true

}

output "egress_address_ranges" {

  value = stackit_ske_cluster.overheid.egress_address_ranges

}

output "pod_address_ranges" {

  value = stackit_ske_cluster.overheid.pod_address_ranges

}
