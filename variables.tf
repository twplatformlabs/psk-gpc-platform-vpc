variable "gc_org_id" {
  type        = string
  description = "The GC organization the project is hosted under"
}

variable "gc_project_id" {
  type        = string
  description = "The project ID to host the network in"
}

variable "gc_network_name" {
  type        = string
  description = "name of gc vpc network"
}

variable "gc_subnets" {
  type = list(object({
    region           = string
    subnet_ip        = string
    secondary_ranges = list(object({
      purpose        = string
      subnet_ip      = string
    }))
  }))
}

variable "share_vpc" {
  type = bool
  description = "Publish VPC as shared to other projects"
  default = true
}
