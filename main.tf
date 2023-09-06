locals {
  subnets_map = flatten([
    for subnet in var.gc_subnets : {
      subnet_name                = "${var.gc_network_name}-${subnet.region}-subnet-01"
      subnet_ip                  = subnet.subnet_ip
      subnet_region              = subnet.region
      subnet_private_access      = true
      subnet_private_ipv6_access = true
      subnet_flow_logs           = false
      secondary_ranges = [
        for secondary_obj in subnet.secondary_ranges : {
          range_name    = "${var.gc_network_name}-${subnet.region}-${secondary_obj.purpose}"
          ip_cidr_range = secondary_obj.subnet_ip
        }
      ]
    }
  ])

  subnets = [
    for subnet in local.subnets_map : {
      subnet_name                = subnet.subnet_name
      subnet_ip                  = subnet.subnet_ip
      subnet_region              = subnet.subnet_region
      subnet_private_access      = subnet.subnet_private_access
      subnet_private_ipv6_access = subnet.subnet_private_ipv6_access
      subnet_flow_logs           = subnet.subnet_flow_logs
    }
  ]

  secondary_ranges = {
    for subnet in local.subnets_map : "${subnet.subnet_name}" => subnet.secondary_ranges
  }
}


module "gc-vpc-module" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "7.3.0"
  project_id                             = var.gc_project_id
  network_name                           = var.gc_network_name
  routing_mode                           = "GLOBAL"
  subnets                                = local.subnets
  secondary_ranges                       = local.secondary_ranges
  delete_default_internet_gateway_routes = true
  shared_vpc_host                        = var.share_vpc
  mtu                                    = 1500

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]
}
