output "network" {
  value = google_compute_network.network
}

output "subnetwork" {
  value = google_compute_subnetwork.subnetwork
}

output "cluster_secondary_range_name" {
  value      = local.cluster_secondary_range_name
  depends_on = [google_compute_subnetwork.subnetwork]
}

output "services_secondary_range_name" {
  value      = local.services_secondary_range_name
  depends_on = [google_compute_subnetwork.subnetwork]
}
