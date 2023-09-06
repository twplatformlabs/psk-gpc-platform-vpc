title "PSK Shared VPC Network"

gc_project_id = input("gc_project_id")
network_name = input("network_name")

describe google_compute_network(project: gc_project_id, name: network_name) do
    it { should exist }
    its('auto_create_subnetworks'){ should be false }
    its('routing_config.routing_mode') { should cmp 'REGIONAL' }
end
