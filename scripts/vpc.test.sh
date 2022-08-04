#!/usr/bin/env bash
export NETWORK=$1
export ENV_PATH=./environments/$1

export TF_VAR_gcp_project_id=$(cat ${ENV_PATH}.auto.tfvars.json.tpl | jq -r .project_id)
export TF_VAR_gcp_network_name=$(cat ${ENV_PATH}.auto.tfvars.json.tpl | jq -r .network_name)
export TF_VAR_gcp_subnets=$(cat ${ENV_PATH}.auto.tfvars.json.tpl | jq -r .subnets)

echo "PROJECT & VPC NAME" $TF_VAR_gcp_project_id $TF_VAR_gcp_network_name
echo "SUBNETS:" $TF_VAR_gcp_subnets
