# Complete Equinix Metal connection (a-side) to GCP (Google Cloud)

~> Equinix Metal connection with automated `a_side` service token is not generally available and may not be enabled yet for your organization.

~> This example is based on the Google Cloud topology to [establish 99.9% availability for Dedicated Interconnect](https://cloud.google.com/network-connectivity/docs/interconnect/tutorials/dedicated-creating-999-availability) where we configure two VLAN attachments in a single Google Cloud region, in separate edge availability domains (metro availability zones) and using a single cloud router.

This example demonstrates usage of the Equinix Connection GCP module to establish two Equinix Fabric L2 Connection from Equinix Metal (a-side) to GCP Interconnect using a redundant [A-Side Token](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/service%20tokens/Fabric-Service-Tokens.htm).
It will:

- Use an existing Equinix Metal project an existing Google Cloud project.
- Create an Equinix Metal VLAN in selected metro Silicon Valley (SV).
- Request an Equinix Metal shared redundant connection in SV.
- Attach the Equinix Metal VLAN to the Virtual Circuit created for the Equinix Metal connection.
- Create a Google Cloud Router.
- Create a Google Cloud Interconnect/VLAN Attachment.
- Provision two Equinix Fabric l2 connection for Google Cloud service profile with specified bandwidth and private peering.
- Finish setting up BGP configuration on GCP side.

## Usage

To provision this example, you should clone the github repository and run terraform from within this directory:

```bash
git clone https://github.com/equinix-labs/terraform-equinix-fabric-connection-gcp.git
cd terraform-equinix-fabric-connection-gcp/examples/service-token-metal-to-gcp-connection
terraform init
terraform apply
```

Note that this example may create resources which cost money. Run 'terraform destroy' when you don't need these resources.

## Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-gcp/equinix/latest/examples/service-token-metal-to-gcp-connection?tab=inputs> for a description of all variables.

## Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-gcp/equinix/latest/examples/service-token-metal-to-gcp-connection?tab=outputs> for a description of all outputs.
