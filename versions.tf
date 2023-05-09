terraform {
  required_version = ">= 0.14"

  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "~> 1.14"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 3.72.0"
    }
  }
  provider_meta "equinix" {
    module_name = "equinix-fabric-connection-gcp"
  }
}
