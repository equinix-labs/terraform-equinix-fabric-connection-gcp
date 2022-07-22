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
  region  = var.gcp_region
}

## Retrieve an existing equinix metal project
## If you prefer you can use resource equinix_metal_project instead to create a fresh project
data "equinix_metal_project" "this" {
  project_id = var.metal_project_id
}

locals {
  connection_name = format("conn-metal-gcp-%s", lower(var.fabric_destination_metro_code))
}

# Create a new VLAN in Frankfurt
resource "equinix_metal_vlan" "this" {
  description = format("VLAN in %s", var.fabric_destination_metro_code)
  metro       = var.fabric_destination_metro_code
  project_id  = data.equinix_metal_project.this.project_id
}

## Request a connection service token in Equinix Metal
resource "equinix_metal_connection" "this" {
    name               = local.connection_name
    project_id         = data.equinix_metal_project.this.project_id
    metro              = var.fabric_destination_metro_code
    redundancy         = var.redundancy_type == "SINGLE" ? "primary" : "redundant"
    type               = "shared"
    service_token_type = "a_side"
    description        = format("connection to GCP in %s", var.fabric_destination_metro_code)
    speed              = format("%dMbps", var.fabric_speed)
    vlans              = [equinix_metal_vlan.this.vxlan]
}

## Configure the Equinix Fabric connection from Equinix Metal to GCP using the metal connection service token
module "equinix-fabric-connection-gcp-primary" {
  source = "equinix-labs/fabric-connection-gcp/equinix"

  fabric_notification_users     = var.fabric_notification_users
  fabric_connection_name        = local.connection_name
  fabric_destination_metro_code = var.fabric_destination_metro_code
  fabric_speed                  = var.fabric_speed
  fabric_service_token_id       = equinix_metal_connection.this.service_tokens.0.id

  # gcp_project = var.gcp_project_name // if unspecified, the project configured in the provided block will be used
  gcp_availability_domain = 1

  gcp_gcloud_skip_download = false
  platform                 = var.platform

  ## BGP config
  gcp_configure_bgp             = true
  # gcp_interconnect_customer_asn = // If unspecified, default value "65000" will be used
}

## If redundancy_type is REDUNDANT, configure a secondary Equinix Fabric connection from Equinix Metal to GCP
## using the metal connection service token
module "equinix-fabric-connection-gcp-secondary" {
  source = "equinix-labs/fabric-connection-gcp/equinix"

  count = var.redundancy_type == "REDUNDANT" ? 1 : 0

  fabric_notification_users     = var.fabric_notification_users
  fabric_connection_name        = local.connection_name
  fabric_destination_metro_code = var.fabric_destination_metro_code
  fabric_speed                  = var.fabric_speed
  fabric_service_token_id       = equinix_metal_connection.this.service_tokens.1.id
  
  gcp_availability_domain   = 2
  gcp_compute_create_router = false // we use the same cloud router of the primary connection
  gcp_compute_router_name   = module.equinix-fabric-connection-gcp-primary.gcp_cloud_router_name

  gcp_gcloud_skip_download = true
  platform                 = var.platform

  ## BGP config
  gcp_configure_bgp             = true
  # gcp_interconnect_customer_asn = // If unspecified, default value "65000" will be used
}
