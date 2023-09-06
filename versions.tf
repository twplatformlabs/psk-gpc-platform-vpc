terraform {
  required_version = "~> 1.2"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.75.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "twdps"
    workspaces {
      prefix = "psk-gcp-platform-vpc-"
    }
  }
}

provider "google" {
  project = var.gc_project_id
  impersonate_service_account = "empc-vpc-sa@${var.gc_project_id}.iam.gserviceaccount.com"
}
