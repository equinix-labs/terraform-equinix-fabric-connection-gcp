# Configure the Equinix Provider
# Please refer to provider documentation for details on supported authentication methods and parameters.
# https://registry.terraform.io/providers/equinix/equinix/latest/docs
provider "equinix" {
  client_id     = var.equinix_provider_client_id
  client_secret = var.equinix_provider_client_secret
}

# Configure the Google Cloud Platform Provider
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials
provider "google" {
  project = var.gcp_project
  # 'region' and 'fabric_destination_metro_code' must correspond to same location.
  # If unspecified, it will use the default region configured with gcloud CLI.
  region  = "europe-west3"
}

module "equinix-fabric-connection-gcp" {
  source = "equinix-labs/fabric-connection-gcp/equinix"

  # required variables
  fabric_notification_users = ["example@equinix.com"]

  # optional variables
  network_edge_device_id     = var.device_id
  network_edge_configure_bgp = true

  fabric_destination_metro_code = "FR"
  fabric_speed                  = 200

  platform                 = "darwin"
  gcp_gcloud_skip_download = true
}
