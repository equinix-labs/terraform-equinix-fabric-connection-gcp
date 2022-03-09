## Equinix Fabric L2 Connection To Google Cloud Interconnect Terraform module

[![Experimental](https://img.shields.io/badge/Stability-Experimental-red.svg)](https://github.com/equinix-labs/standards#about-uniform-standards)
[![terraform](https://github.com/equinix-labs/terraform-equinix-template/actions/workflows/integration.yaml/badge.svg)](https://github.com/equinix-labs/terraform-equinix-template/actions/workflows/integration.yaml)

`terraform-equinix-fabric-connection-gcp` is a Terraform module that utilizes [Terraform provider for Equinix](https://registry.terraform.io/providers/equinix/equinix/latest) and [Terraform provider for Google](https://registry.terraform.io/providers/hashicorp/google/latest/docs) to set up an Equinix Fabric L2 connection to Google Cloud Interconnect.

As part of Platform Equinix, your infrastructure can connect with other parties, such as public cloud providers, network service providers, or your own colocation cages in Equinix by defining an [Equinix Fabric - software-defined interconnection](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/Fabric-landing-main.htm).

This module creates a Cloud router or uses an existing one, an InterconnectAttachment in Google Cloud, and the l2 connection in Equinix Fabric using the InterconnectAttachment pairing key.

```html
     Origin                                              Destination
    (A-side)                                              (Z-side)

┌────────────────┐
│ Equinix Fabric │         Equinix Fabric          ┌────────────────────┐       ┌───────────────────────┐
│ Port / Network ├─────    l2 connection   ───────►│        GCP         │──────►│  Clour Router ─► VPC  │
│ Edge Device /  │      (50 Mbps - 10 Gbps)        │    Interconnect    │       │                       │
│ Service Token  │                                 └────────────────────┘       └───────────────────────┘
└────────────────┘
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

output "connection_details" {
  value = module.equinix-fabric-connection-gcp
}

```

Run `terraform init -upgrade` and `terraform apply`.

#### Resources

| Name | Type |
| :-----: | :------: |
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [equinix-fabric-connection](https://registry.terraform.io/modules/equinix-labs/fabric-connection/equinix/latest?tab=inputs) | module |
| [google_compute_interconnect_attachment.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_interconnect_attachment) | resource |
| [google_compute_router.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_router) | data source |

#### Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-gcp/equinix/latest?tab=inputs> for a description of all variables.

#### Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-gcp/equinix/latest?tab=outputs> for a description of all outputs.

### Examples

- [examples/simple](examples/simple/)
