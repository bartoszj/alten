// Name
variable "name" {
  type        = string
  description = "Node pool name"
}

// Cluster
variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

// Pool
variable "initial_node_count" {
  type        = number
  default     = 1
  description = "Initial number of nodes in pool"
}

variable "min_node_count" {
  type        = number
  default     = 1
  description = "Minimal number of nodes in pool"
}

variable "max_node_count" {
  type        = number
  default     = 1
  description = "Maximum number of nodes in pool"
}

variable "machine_type" {
  type        = string
  default     = "e2-small"
  description = "Machine type"
}

variable "image_type" {
  type        = string
  default     = "UBUNTU"
  description = "Machine image type"
}

variable "preemptible" {
  type        = bool
  default     = false
  description = "Use preemptible nodes"
}

variable "disk_size" {
  type        = number
  default     = 50
  description = "Node disk size"
}

variable "disk_type" {
  type        = string
  default     = "pd-standard"
  description = "Node disk type"
}

variable "network_tags" {
  type        = list(string)
  default     = ["gke"]
  description = "Node network tags"
}