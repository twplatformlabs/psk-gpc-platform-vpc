## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.30.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp-vpc-module"></a> [gcp-vpc-module](#module\_gcp-vpc-module) | terraform-google-modules/network/google | 5.1.0 |

## Resources

| Name | Type |
|------|------|
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/4.30.0/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_network_name"></a> [gcp\_network\_name](#input\_gcp\_network\_name) | name of gcp vpc network | `any` | n/a | yes |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | The project ID to host the network in | `any` | n/a | yes |
| <a name="input_gcp_subnets"></a> [gcp\_subnets](#input\_gcp\_subnets) | n/a | <pre>list(object({<br>    region = string    <br>    subnet_ip = string<br>    secondary_ranges = list(object({<br>      purpose = string<br>      subnet_ip = string<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_regional_cluster"></a> [regional\_cluster](#input\_regional\_cluster) | increase the availability of both a cluster's control plane and its nodes by replicating them across multiple zones in a region. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secondary"></a> [secondary](#output\_secondary) | n/a |
