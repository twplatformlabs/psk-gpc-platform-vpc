#!/usr/bin/env bash
export ENVIRONMENT=$1

gcloud auth login --cred-file=./gcp-creds.json &>/dev/null
gcloud config set auth/impersonate_service_account empc-vpc-sa@${GCP_PROJECT_ID}.iam.gserviceaccount.com &>/dev/null

inspec exec tests/lab-gcp-platform-vpc -t gcp:// --input gcp_project_id=${GCP_PROJECT_ID}

#Unset impersonation (mostly for local testing and caches)
gcloud config unset auth/impersonate_service_account &>/dev/null
