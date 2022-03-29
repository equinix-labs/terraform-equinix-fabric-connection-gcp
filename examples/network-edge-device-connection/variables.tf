variable "project_name" {
  type        = string
  description = "The default GCP project to manage resources in."
}

variable "device_id" {
  type = string
  description = <<EOF
  The ID of the (Network Edge virtual device](https://github.com/equinix/terraform-provider-equinix/tree/master/examples/edge-networking)
  from which the connection would originate.
  EOF
}
