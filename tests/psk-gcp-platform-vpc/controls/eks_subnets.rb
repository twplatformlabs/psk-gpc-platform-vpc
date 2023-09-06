title "PSK EKS VPC Subnets"

gc_project_id = input("gc_project_id")

describe google_compute_subnetworks(project: gc_project_id) do
    its('regions') { should include 'us-east1'.and 'us-west1'.and 'us-central1' }
end
