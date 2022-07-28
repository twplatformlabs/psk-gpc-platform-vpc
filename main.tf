locals {
  subnets = flatten([
    for subnet in var.gcp_subnets: {
      # TODO - nw name should map to primary/secondary purpose, like pod or services nw
      subnet_name           = "${var.gcp_network_name}-${subnet.region}-subnet-01"
      subnet_ip             = subnet.subnet_ip
      subnet_region         = subnet.region
      subnet_private_access = "false"
      subnet_flow_logs      = "false"
    }
  ])
}


module "gcp-vpc-module" {
  source  = "terraform-google-modules/network/google"
  version = "5.1.0"
  project_id   = var.gcp_project_id
  network_name = var.gcp_network_name

  subnets = local.subnets
  # TODO - secondary_ranges for pod networks
  # TODO - routes for igw egress
}
