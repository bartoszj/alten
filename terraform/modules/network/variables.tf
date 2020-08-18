variable "name" {
  default     = "alten"
  type        = string
  description = "Network name"
}

// Subnetwork
variable "ip_cidr_range" {
  type        = string
  description = "IP range for subnetwork"
}

variable "ip_cidr_range_gke_pods" {
  type        = string
  description = "Range to use for kubernetes pods subnet. Suggested mask: /14"
}

variable "ip_cidr_range_gke_services" {
  type        = string
  description = "Range to use for kubernetes services subnet. Suggested mask: /20"
}
