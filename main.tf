locals {
  subnets_map = flatten([
    for subnet in var.gcp_subnets: {
      subnet_name           = "${var.gcp_network_name}-${subnet.region}-subnet-01"
      subnet_ip             = subnet.subnet_ip
      subnet_region         = subnet.region
      subnet_private_access = "false"
      subnet_flow_logs      = "false"
      secondary_ranges      = [
        for secondary_obj in subnet.secondary_ranges : {
          range_name = "${var.gcp_network_name}-${subnet.region}-${secondary_obj.purpose}"
          ip_cidr_range = secondary_obj.subnet_ip
        }
      ]
    }
  ])

  subnets = [
    for subnet in local.subnets_map : {
      subnet_name = subnet.subnet_name
      subnet_ip = subnet.subnet_ip
      subnet_region =  subnet.subnet_region
      subnet_private_access = subnet.subnet_private_access
      subnet_flow_logs = subnet.subnet_flow_logs
    }
  ]

  secondary_ranges = {
    for subnet in local.subnets_map : "${subnet.subnet_name}" => subnet.secondary_ranges
  }

}


module "gcp-vpc-module" {
  source  = "terraform-google-modules/network/google"
  version = "5.1.0"
  project_id   = var.gcp_project_id
  network_name = var.gcp_network_name

  subnets = local.subnets

  secondary_ranges = local.secondary_ranges

  # TODO - routes for igw egress
}

data "google_client_config" "default" {}
