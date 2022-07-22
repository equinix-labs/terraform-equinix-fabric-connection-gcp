# Fabric Port Connection Example

This example demonstrates usage of the Equinix Connection GCP module to establish a non-redundant Equinix Fabric L2 Connection from a Equinix Fabric port to Google Cloud Interconnect. It will:

- Use an existing GCP project.
- Use 'default' VPC.
- Create a Google Cloud Router.
- Create a Google Cloud Interconnect/VLAN Attachment.
- Create an Equinix Fabric l2 connection with minimun available bandwidth for Google Cloud service profile.

## Usage

To provision this example, you should clone the github repository and run terraform from within this directory:

```bash
git clone https://github.com/equinix-labs/terraform-equinix-fabric-connection-gcp.git
cd terraform-equinix-fabric-connection-gcp/examples/fabric-port-connection
terraform init
terraform apply
```

Note that this example may create resources which cost money. Run 'terraform destroy' when you don't need these resources.

## Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-gcp/equinix/latest/examples/fabric-port-connection?tab=inputs> for a description of all variables.

## Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-gcp/equinix/latest/examples/fabric-port-connection?tab=outputs> for a description of all outputs.
