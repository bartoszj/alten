// Name
variable "name" {
  type    = string
  default = "gke-cluster"
}

variable "network_name" {
  type        = string
  description = "Existing network name"
}

variable "subnetwork_name" {
  type        = string
  description = "Existing GKE subnetwork name"
}

// Subnetwork
variable "ip_cidr_range_master" {
  type        = string
  description = "GKE Master nodes IP range. Suggested mask: /28"
}

variable "cluster_secondary_range_name" {
  type        = string
  description = "Range to use for kubernetes pods subnet"
}

variable "services_secondary_range_name" {
  type        = string
  description = "Range to use for kubernetes services subnet"
}

// Cluster configuration
variable "kubernetes_version" {
  type    = string
  default = "1.15.12-gke.2"
}

variable "initial_node_count" {
  type    = number
  default = 1
}

variable "daily_maintenance_window" {
  type    = string
  default = "02:00"
}

variable "network_tags" {
  type        = list(string)
  default     = ["gke"]
  description = "Network tag"
}

// Authorized networks
variable "authorized_networks" {
  type = list(object({ cidr : string, description : string }))
  default = [
    {
      cidr        = "1.2.3.4/32"
      description = "Private"
    },
    {
      cidr        = "34.0.0.0/8"
      description = "GCE instances / Cloud Console"
    },
  ]
}
