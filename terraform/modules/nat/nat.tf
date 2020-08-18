resource "google_compute_address" "nat-address" {
  name         = "nat"
  network_tier = "STANDARD"
}

data "google_client_config" "current" {
}

data "google_compute_zones" "zones" {
  region = data.google_client_config.current.region
}

// https://cloud.google.com/vpc/docs/special-configurations#natgateway
resource "google_compute_instance" "nat-box" {
  machine_type = var.nat_machine_type
  name         = "nat-box"
  zone         = data.google_compute_zones.zones.names[0]
  tags         = ["nat-box"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
    auto_delete = true
  }
  network_interface {
    subnetwork = var.subnetwork_name
    access_config {
      nat_ip       = google_compute_address.nat-address.address
      network_tier = "STANDARD"
    }
  }
  can_ip_forward            = true
  allow_stopping_for_update = true
  metadata = {
    enable-oslogin = "TRUE"
  }
  metadata_startup_script = "sysctl -w net.ipv4.ip_forward=1; iptables -t nat -A POSTROUTING -o $(/sbin/ifconfig | head -1 | awk -F: {'print $1'}) -j MASQUERADE"
}

resource "google_compute_route" "nat-box-route" {
  name        = "nat-box-default-route"
  description = "Network NAT"
  network     = var.network_name
  dest_range  = "0.0.0.0/0"
  tags        = var.source_tags
  priority    = 1000

  next_hop_instance      = google_compute_instance.nat-box.self_link
  next_hop_instance_zone = google_compute_instance.nat-box.zone
}
