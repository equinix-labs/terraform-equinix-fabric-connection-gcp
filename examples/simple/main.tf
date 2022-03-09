provider "equinix" {}

provider "google" {
  project     = "example"
  region      = "europe-west3"
}

variable "port_name" {}

module "equinix-fabric-connection-gcp" {
  source = "github.com/equinix-labs/terraform-equinix-fabric-connection-gcp"

  # required variables
  fabric_notification_users = ["example@equinix.com"]

  # optional variables
  fabric_port_name              = var.port_name
  fabric_vlan_stag              = 1010
  fabric_destination_metro_code = "FR"
}

output "connection_details" {
  value = module.equinix-fabric-connection-gcp
}
