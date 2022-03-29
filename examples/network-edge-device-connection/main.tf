provider "equinix" {}

provider "google" {
  project = var.project_name
  region  = "europe-west3"
}

module "equinix-fabric-connection-gcp" {
  source = "github.com/equinix-labs/terraform-equinix-fabric-connection-gcp"

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
