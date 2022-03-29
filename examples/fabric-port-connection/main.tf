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
  fabric_port_name              = var.port_name
  fabric_vlan_stag              = 1010
  fabric_destination_metro_code = "FR"
}
