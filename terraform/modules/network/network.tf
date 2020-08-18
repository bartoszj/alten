locals {
  cluster_secondary_range_name  = "gke-cluster-ips"
  services_secondary_range_name = "gke-services-ips"
}

// VPC
resource "google_compute_network" "network" {
  name                    = var.name
  auto_create_subnetworks = false
}

// Subnetwork for GKE cluster nodes
resource "google_compute_subnetwork" "subnetwork" {
  name                     = var.name
  ip_cidr_range            = var.ip_cidr_range
  network                  = google_compute_network.network.self_link
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = local.services_secondary_range_name
    ip_cidr_range = var.ip_cidr_range_gke_services
  }

  secondary_ip_range {
    range_name    = local.cluster_secondary_range_name
    ip_cidr_range = var.ip_cidr_range_gke_pods
  }
}
