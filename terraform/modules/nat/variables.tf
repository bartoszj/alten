// NAT machine type
variable "nat_machine_type" {
  type        = string
  default     = "f1-micro"
  description = "NAT instance machine type"
}

variable "network_name" {
  type        = string
  description = "Network name where cloud routes will be created"
}

variable "subnetwork_name" {
  type        = string
  description = "Subnetwork name where NAT Box will be created"
}

// Firewall
variable "source_tags" {
  type        = list(string)
  description = "List of network tags which can access NAT box"
}
