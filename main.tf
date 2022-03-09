locals {
  gcp_compute_router_name = coalesce(var.gcp_compute_router_name, lower(format("router-%s", random_string.this.result)))
  gcp_compute_router_id   = var.gcp_compute_create_router ? google_compute_router.this[0].id : data.google_compute_router.this[0].id
  gcp_region              = coalesce(var.gcp_region, data.google_client_config.this.region)
}

data "google_client_config" "this" {}

data "google_compute_router" "this" {
  count = var.gcp_compute_create_router ? 0 : 1

  name    = local.gcp_compute_router_name
  network = var.gcp_compute_network_name
}

resource "google_compute_router" "this" {
  count = var.gcp_compute_create_router ? 1 : 0

  name    = local.gcp_compute_router_name
  network = var.gcp_compute_network_name
  region  = local.gcp_region

  bgp {
    asn = 16550
  }
}

resource "random_string" "this" {
  length  = 3
  special = false
}

resource "google_compute_interconnect_attachment" "this" {
  name   = coalesce(var.gcp_compute_interconnect_name, lower(format("interconnect-%s", random_string.this.result)))
  type   = "PARTNER"
  router = local.gcp_compute_router_id
  region = local.gcp_region

  edge_availability_domain = format("AVAILABILITY_DOMAIN_%d", var.gcp_availability_domain)
}

module "equinix-fabric-connection" {
  # source = "github.com/equinix-labs/terraform-equinix-fabric-connection"
  source = "../terraform-equinix-fabric-connection"

  # required variables
  notification_users = var.fabric_notification_users

  # optional variables
  name = var.fabric_connection_name

  seller_profile_name       = format("Google Cloud Partner Interconnect Zone %d", var.gcp_availability_domain)
  seller_metro_code         = var.fabric_destination_metro_code
  seller_metro_name         = var.fabric_destination_metro_name
  seller_region             = local.gcp_region
  seller_authorization_key  = google_compute_interconnect_attachment.this.pairing_key

  network_edge_id           = var.network_edge_device_id
  network_edge_interface_id = var.network_edge_device_interface_id
  port_name                 = var.fabric_port_name
  vlan_stag                 = var.fabric_vlan_stag
  service_token_id          = var.fabric_service_token_id
  speed                     = var.fabric_speed
  speed_unit                = var.fabric_speed_unit
  purcharse_order_number    = var.fabric_purcharse_order_number
}
