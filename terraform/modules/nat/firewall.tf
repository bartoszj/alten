// Allow Google IAP TCP Forwarding to connect to NAT Box
resource "google_compute_firewall" "iap-to-nat-box" {
  name          = "iap-to-nat-box"
  network       = var.network_name
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["nat-box"]

  // Allow SSH
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

// Allow Nodes use NAT Box
resource "google_compute_firewall" "nodes-to-nat-box" {
  name        = "nodes-to-nat-box"
  network     = var.network_name
  source_tags = var.source_tags
  target_tags = ["nat-box"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }
}
