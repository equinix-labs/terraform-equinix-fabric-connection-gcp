## Equinix Fabric L2 Connection To Google Cloud Interconnect Terraform module

[![Experimental](https://img.shields.io/badge/Stability-Experimental-red.svg)](https://github.com/equinix-labs/standards#about-uniform-standards)
[![terraform](https://github.com/equinix-labs/terraform-equinix-template/actions/workflows/integration.yaml/badge.svg)](https://github.com/equinix-labs/terraform-equinix-template/actions/workflows/integration.yaml)

`terraform-equinix-fabric-connection-gcp` is a Terraform module that utilizes [Terraform provider for Equinix](https://registry.terraform.io/providers/equinix/equinix/latest) and [Terraform provider for Google](https://registry.terraform.io/providers/hashicorp/google/latest/docs) to set up an Equinix Fabric L2 connection to Google Cloud Interconnect.

As part of Platform Equinix, your infrastructure can connect with other parties, such as public cloud providers, network service providers, or your own colocation cages in Equinix by defining an [Equinix Fabric - software-defined interconnection](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/Fabric-landing-main.htm).

This module creates a Cloud router or uses an existing one, an InterconnectAttachment in Google Cloud, and the l2 connection in Equinix Fabric using the InterconnectAttachment pairing key. BGP can be optionally configured in both sides if Network Edge device is used.

```html
     Origin                                              Destination
    (A-side)                                              (Z-side)

┌────────────────┐
│ Equinix Fabric │         Equinix Fabric          ┌────────────────────┐       ┌────────────────┐
│ Port / Network ├─────    l2 connection   ───────►│        GCP         │──────►│  Clour Router  │
│ Edge Device /  │      (50 Mbps - 10 Gbps)        │    Interconnect    │       │                │
│ Service Token  │                                 └────────────────────┘       └────────────────┘
└────────────────┘                                                                   │
         │                                                                           │
         └ - - - - - - - - - - Network Edge Device - - - - - - - - - - - - - - - - - ┘
                                   BGP peering
```

### Usage

This project is experimental and supported by the user community. Equinix does not provide support for this project.

Install Terraform using the official guides at <https://learn.hashicorp.com/tutorials/terraform/install-cli>.

This project may be forked, cloned, or downloaded and modified as needed as the base in your integrations and deployments.

This project may also be used as a [Terraform module](https://learn.hashicorp.com/collections/terraform/modules).

To use this module in a new project, create a file such as:

```hcl
# main.tf
provider "equinix" {}

provider "google" {
  project     = "example"
  region      = "europe-west3"
}

variable "port_name" {}

module "equinix-fabric-connection-gcp" {
  source  = "equinix-labs/fabric-connection-gcp/equinix"

  # required variables
  fabric_notification_users = ["example@equinix.com"]

  # optional variables
  fabric_port_name              = var.port_name
  fabric_vlan_stag              = 1010
  fabric_destination_metro_code = "FR"
}

```

Run `terraform init -upgrade` and `terraform apply`.

-> **NOTE:**
Completing BGP configuration in GCP side is not directly supported with current google terraform provider (v3.72.0). As a workaround this module take advantage of [terraform-google-gcloud](https://registry.terraform.io/modules/terraform-google-modules/gcloud/google/latest) module which allows use gcloud. However, it is only available for `linux` and `darwin` based operating systems. To run this module in a non-supported platfom, 'network_edge_configure_bgp' and 'gcp_configure_bgp' must remain false. Check this [issue](https://github.com/hashicorp/terraform-provider-google/issues/9582) to obtain further information.

### Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-gcp/equinix/latest?tab=inputs> for a description of all variables.

### Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-gcp/equinix/latest?tab=outputs> for a description of all outputs.

### Resources

| Name | Type |
|------|------|
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [equinix-fabric-connection](https://registry.terraform.io/modules/equinix-labs/fabric-connection/equinix/latest) | module |
| [equinix_network_bgp.this](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/equinix_network_bgp) | resource |
| [google_compute_interconnect_attachment.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_interconnect_attachment) | resource |
| [google_compute_router.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_router) | data source |
| [gcloud-configure-bgp](https://registry.terraform.io/modules/terraform-google-modules/gcloud/google/latest) | module |
| [gcloud-get-bgp-addresses](https://registry.terraform.io/modules/terraform-google-modules/gcloud/google/latest) | module |
| [local_file.this](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

### Examples

- [Fabric Port connection](https://registry.terraform.io/modules/equinix-labs/fabric-connection-gcp/equinix/latest/examples/fabric-port-connection/)
- [Network Edge device connection](https://registry.terraform.io/modules/equinix-labs/fabric-connection-gcp/equinix/latest/examples/network-edge-device-connection/)
