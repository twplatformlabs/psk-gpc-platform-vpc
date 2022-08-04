variable "gcp_project_id" {
  type        = string
  description = "The project ID to host the network in"
}

variable "gcp_network_name" {
  type        = string
  description = "name of gcp vpc network"
}

variable "gcp_subnets" {
  type = list(object({
    region           = string    
    subnet_ip        = string
    secondary_ranges = list(object({
      purpose        = string
      subnet_ip      = string
    }))
  }))
}

variable "regional_cluster" {
  description = "increase the availability of both a cluster's control plane and its nodes by replicating them across multiple zones in a region."
  default     = true # we believe this should be on by default
}
