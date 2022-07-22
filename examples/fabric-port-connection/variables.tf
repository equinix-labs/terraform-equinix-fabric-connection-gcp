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

variable "fabric_port_name" {
  type        = string
  description = "(Required) Name of the [Equinix Fabric port](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/ports/Fabric-port-details.htm) from which the connection would originate."
}
