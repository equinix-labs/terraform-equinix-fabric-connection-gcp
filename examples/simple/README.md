# Simple Example

This example demonstrates usage of the Equinix Connection module to establish a non-redundant Equinix Fabric L2 Connection from a Equinix Fabric port to Google Cloud Interconnect. It will:

- Use VPC 'default'
- Use default project specified in gcloud cli / credentials file
- Create Google Cloud Router, if does not exist
- Create Google Cloud Interconnect/VLAN Attachment
- Create Equinix Fabric l2 connection with minimun available bandwidth for Google Cloud service profile

## Usage

```bash
terraform init
terraform apply
```
