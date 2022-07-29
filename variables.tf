variable "gcp_project_id" {
  description = "The project ID to host the network in"
}

variable "gcp_network_name" {
  description = "name of gcp vpc network"
}

variable "gcp_subnets" {
  type = list(object({
    region = string    
    subnet_ip = string
    secondary_ranges = list(object({
      purpose = string
      subnet_ip = string
    }))
  }))
}
