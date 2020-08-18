resource "google_container_cluster" "cluster" {
  name        = var.name
  location    = data.google_client_config.current.region
  description = "Kubernetes cluster"
  network     = var.network_name
  subnetwork  = var.subnetwork_name

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count
  min_master_version       = var.kubernetes_version

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  // Private Cluster Settings:
  // https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters
  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  private_cluster_config {
    enable_private_endpoint = false

    # Allows access to API from outside internal subnet
    enable_private_nodes = true

    # Nodes will have only private addresses
    master_ipv4_cidr_block = var.ip_cidr_range_master
  }

  // Enable Network Policy
  network_policy {
    enabled  = true
    provider = "CALICO" // CALICO is currently the only supported provider
  }

  // Enable Network Policy
  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  // Kubernetes metrics
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  // Allows access to Master from Offices and Jenkins
  master_authorized_networks_config {
    dynamic cidr_blocks {
      for_each = var.authorized_networks
      content {
        cidr_block   = cidr_blocks.value.cidr
        display_name = cidr_blocks.value.description
      }
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.daily_maintenance_window
    }
  }

  resource_labels = {
    type = "k8s"
  }
}
