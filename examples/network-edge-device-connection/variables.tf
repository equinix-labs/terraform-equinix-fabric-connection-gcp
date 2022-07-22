variable "equinix_provider_client_id" {
  type        = string
  description = <<EOF
  API Consumer Key available under 'My Apps' in developer portal. This argument can also be specified with the
  EQUINIX_API_CLIENTID shell environment variable.
  EOF
  default     = null
}

variable "equinix_provider_client_secret" {
  type        = string
  description = <<EOF
  API Consumer secret available under 'My Apps' in developer portal. This argument can also be specified with the
  EQUINIX_API_CLIENTSECRET shell environment variable.
  EOF
  default     = null
}

variable "gcp_project" {
  type        = string
  description = "(Required) Name of the GCP project to manage resources in."
}

variable "device_id" {
  type = string
  description = <<EOF
  The ID of the (Network Edge virtual device](https://github.com/equinix/terraform-provider-equinix/tree/master/examples/edge-networking)
  from which the connection would originate.
  EOF
}
