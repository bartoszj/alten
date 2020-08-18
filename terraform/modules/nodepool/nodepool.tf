locals {
  // The following scopes are necessary to ensure the correct functioning of the cluster:
  gke_scopes = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}

resource "google_container_node_pool" "pool" {
  name               = var.name
  location           = data.google_client_config.current.region
  cluster            = var.cluster_name
  initial_node_count = var.initial_node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = var.machine_type
    image_type   = var.image_type
    preemptible  = var.preemptible

    disk_size_gb = var.disk_size
    disk_type    = var.disk_type

    // The following scopes are necessary to ensure the correct functioning of the cluster:
    oauth_scopes = local.gke_scopes

    service_account = data.google_compute_default_service_account.default.email

    // Labels to have some information for humans and possibility to use search
    tags = var.network_tags

    labels = {
      type      = "k8s"
      node_type = var.name
    }

    metadata = {
      // Workaround https://github.com/terraform-providers/terraform-provider-google/issues/3230
      disable-legacy-endpoints = "true"
    }
  }
}
