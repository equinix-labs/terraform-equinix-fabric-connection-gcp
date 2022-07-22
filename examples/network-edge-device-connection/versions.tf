terraform {  
  required_version = ">= 0.13"

  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = ">= 1.7.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 3.72.0"
    }
  }
}
