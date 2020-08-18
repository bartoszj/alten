module "cluster" {
  source = "../modules/gke"

  network_name                  = module.network.network.name
  subnetwork_name               = module.network.subnetwork.name
  ip_cidr_range_master          = var.google_gke_cidr_range_master
  cluster_secondary_range_name  = module.network.cluster_secondary_range_name
  services_secondary_range_name = module.network.services_secondary_range_name
}

module "nodepool" {
  source = "../modules/nodepool"

  name         = "nodes-pool"
  preemptible  = true
  cluster_name = module.cluster.cluster.name
}
