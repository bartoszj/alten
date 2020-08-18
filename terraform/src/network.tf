module "network" {
  source = "../modules/network"

  ip_cidr_range              = var.google_gke_subnetwork_address_range
  ip_cidr_range_gke_pods     = var.google_gke_pod_address_range
  ip_cidr_range_gke_services = var.google_gke_service_address_range
}

module "nat" {
  source = "../modules/nat"

  source_tags     = ["gke"]
  network_name    = module.network.network.name
  subnetwork_name = module.network.subnetwork.name
}
