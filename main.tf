locals {
  gcp_compute_router_name     = coalesce(var.gcp_compute_router_name, lower(format("router-%s", random_string.this.result)))
  gcp_compute_router_id       = var.gcp_compute_create_router ? google_compute_router.this[0].id : data.google_compute_router.this[0].id
  gcp_region                  = coalesce(var.gcp_region, data.google_client_config.this.region)
  gcp_project                 = coalesce(var.gcp_project, data.google_client_config.this.project)
  gcp_network                 = data.google_compute_network.this.id
  gcp_bgp_addresses           = try(jsondecode(data.local_file.this[0].content), null)
  gcp_bgp_addresses_file_path = "${path.module}/gcp_peering_addresses.json"
}

data "google_client_config" "this" {}

data "google_compute_network" "this" {
  name = var.gcp_compute_network_name
}

data "google_compute_router" "this" {
  count = var.gcp_compute_create_router ? 0 : 1

  name    = local.gcp_compute_router_name
  network = local.gcp_network
}

resource "google_compute_router" "this" {
  count = var.gcp_compute_create_router ? 1 : 0

  name    = local.gcp_compute_router_name
  network = local.gcp_network
  region  = local.gcp_region

  bgp {
    asn               = 16550
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
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
  source  = "equinix-labs/fabric-connection/equinix"
  version = "0.6.0"

  # required variables
  notification_users = var.fabric_notification_users

  # optional variables
  name = var.fabric_connection_name

  seller_profile_name      = format("Google Cloud Partner Interconnect Zone %d", var.gcp_availability_domain)
  seller_metro_code        = var.fabric_destination_metro_code
  seller_metro_name        = var.fabric_destination_metro_name
  seller_region            = local.gcp_region
  seller_authorization_key = google_compute_interconnect_attachment.this.pairing_key

  network_edge_id           = var.network_edge_device_id
  network_edge_interface_id = var.network_edge_device_interface_id
  port_name                 = var.fabric_port_name
  vlan_stag                 = var.fabric_vlan_stag
  service_token_id          = var.fabric_service_token_id
  speed                     = var.fabric_speed
  purchase_order_number     = var.fabric_purchase_order_number
}

module "gcloud-configure-bgp" {
  source  = "terraform-google-modules/gcloud/google"
  version = "3.4.1"
  enabled = anytrue([var.gcp_configure_bgp, var.network_edge_configure_bgp])

  skip_download = var.gcp_gcloud_skip_download
  platform      = var.platform
  upgrade       = false

  create_cmd_body = join(" ", ["compute routers update-bgp-peer ${local.gcp_compute_router_id}",
    "--peer-name=$(gcloud compute routers describe ${local.gcp_compute_router_id} --region=${local.gcp_region} --project=${local.gcp_project} --format=\"value(bgpPeers.name)\")",
    "--peer-asn=${var.gcp_interconnect_customer_asn}",
    "--advertisement-mode=CUSTOM",
    "--set-advertisement-groups=ALL_SUBNETS",
    "--region=${local.gcp_region}",
  "--project=${local.gcp_project}"])

  module_depends_on = [
    module.equinix-fabric-connection,
  ]
}

module "gcloud-get-bgp-addresses" {
  source  = "terraform-google-modules/gcloud/google"
  version = "3.4.1"
  enabled = anytrue([var.gcp_configure_bgp, var.network_edge_configure_bgp])

  platform      = var.platform
  skip_download = true
  upgrade       = false

  create_cmd_entrypoint = "${path.module}/scripts/gcp_get_bgp_addresses.sh"
  create_cmd_body = join(" ", [
    google_compute_interconnect_attachment.this.name,
    local.gcp_region,
    local.gcp_project,
    local.gcp_bgp_addresses_file_path,
    var.gcp_gcloud_skip_download ? "gcloud" : abspath("${module.gcloud-configure-bgp.bin_dir}/gcloud"),
  var.gcp_gcloud_skip_download ? "jq" : abspath("${module.gcloud-configure-bgp.bin_dir}/jq")])

  destroy_cmd_entrypoint = "echo"
  destroy_cmd_body       = "'# This file is auto-generated by equinix-labs/fabric-connection-gcp/equinix terraform module.' > ${local.gcp_bgp_addresses_file_path}"

  module_depends_on = [
    module.gcloud-configure-bgp.wait,
  ]
}

data "local_file" "this" {
  count = anytrue([var.gcp_configure_bgp, var.network_edge_configure_bgp]) ? 1 : 0

  filename = local.gcp_bgp_addresses_file_path

  depends_on = [
    module.gcloud-get-bgp-addresses.wait,
  ]
}

resource "equinix_network_bgp" "this" {
  count = alltrue([var.network_edge_device_id != "", var.network_edge_configure_bgp]) ? 1 : 0

  connection_id     = module.equinix-fabric-connection.primary_connection.uuid
  local_ip_address  = local.gcp_bgp_addresses.customer_router_ip
  local_asn         = tonumber(var.gcp_interconnect_customer_asn)
  remote_ip_address = split("/", local.gcp_bgp_addresses.cloud_router_ip)[0]
  remote_asn        = 16550

  depends_on = [
    module.gcloud-get-bgp-addresses.wait,
  ]
}
