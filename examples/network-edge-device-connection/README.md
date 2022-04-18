# Network Edge Device Connection Example

This example demonstrates usage of the Equinix Connection GCP module to establish a non-redundant Equinix Fabric L2 Connection from a Equinix Network Edge device to Google Cloud Interconnect. It will:

- Use 'default' VPC.
- Use the `project` specified in provider.
- Create a Google Cloud Router.
- Create a Google Cloud Interconnect/VLAN Attachment.
- Create Equinix Fabric l2 connection with 200 Mbps bandwidth.
- Configure BGP session between the GCP cloud router and your Network Edge device.

## Usage

To provision this example, you should clone the github repository and run terraform from within this directory:

```bash
git clone https://github.com/equinix-labs/terraform-equinix-fabric-connection-gcp.git
cd terraform-equinix-fabric-connection-gcp/examples/network-edge-device-connection
terraform init
terraform apply
```

Note that this example may create resources which cost money. Run 'terraform destroy' when you don't need these resources.

## Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-gcp/equinix/latest/examples/network-edge-device-connection?tab=inputs> for a description of all variables.

## Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-gcp/equinix/latest/examples/network-edge-device-connection?tab=outputs> for a description of all outputs.
