terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "google" {
  //  credentials = file("/mnt/c/Users/lidv280/Downloads/playground-s-11-f8d3b3ed-a9185f19a328.json")
  credentials = file("${var.credentials}")
  project     = var.gcp_project_id
}

provider "google-beta" {
  //  credentials = file("/mnt/c/Users/lidv280/Downloads/playground-s-11-f8d3b3ed-a9185f19a328.json")
  credentials = file("${var.credentials}")
  project     = var.gcp_project_id
}

//credentials = file("${var.credentials}")
