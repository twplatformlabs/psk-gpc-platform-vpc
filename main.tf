locals {
  subnets_map = flatten([
    for subnet in var.gcp_subnets: {
      # TODO - nw name should map to primary/secondary purpose, like pod or services nw
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

# TODO - output required network values in vpc module to consume in below module
# TODO - move to sep module
module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google"
  version                = "22.0.0"
  count                  = length(local.subnets_map)
  project_id             = var.gcp_project_id
  name                   = "test-cluster"
  region                 = local.subnets_map[count.index].subnet_region
  regional               = var.regional_cluster
  network                = var.gcp_network_name
  network_project_id     = var.gcp_project_id
  subnetwork             = local.subnets_map[count.index].subnet_name
  # TODO - refactor these to fetch by key name, not 0/1 index
  ip_range_pods          = local.secondary_ranges[ local.subnets_map[count.index].subnet_name ][0].range_name
  ip_range_services      = local.secondary_ranges[ local.subnets_map[count.index].subnet_name ][1].range_name
  create_service_account = true

  node_pools = [
    {
      name               = "base-node-pool"
      machine_type       = "e2-medium"
      min_count          = 1
      max_count          = 3
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 3
    },
  ]
}
