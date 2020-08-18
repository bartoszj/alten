variable "google_gke_subnetwork_address_range" {
  type        = string
  default     = "172.16.0.0/20"
  description = "The GKE Subnetwork address range"
}

variable "google_gke_cidr_range_master" {
  type        = string
  default     = "172.16.16.0/28"
  description = "The GKE Master nodes IP range."
}

variable "google_gke_pod_address_range" {
  type        = string
  default     = "10.0.0.0/14"
  description = "The GKE Pod address range"
}

variable "google_gke_service_address_range" {
  type        = string
  default     = "10.4.0.0/20"
  description = "The GKE Service address range"
}
