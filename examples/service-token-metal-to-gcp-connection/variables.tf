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
  description = "(Required) ID of the GCP project to manage resources in."
}

variable "gcp_region" {
  type        = string
  description = <<EOF
  The region in which the GCP resources and the Equinix port for GCP resides, i.e. 'us-west2'. If unspecified, this
  defaults to the region configured in the google provider.
  
  NOTE: 'var.gcp_region' and 'var.fabric_destination_metro_code' must correspond to same location."
  EOF
  default     = "us-west2" // Corresponds to Silicon Valley (SV) and Los Angeles (LA).
}

variable "metal_project_id" {
  type        = string
  description = "ID of the project where the connection is scoped to, used to look up the project."
}

variable "fabric_notification_users" {
  type        = list(string)
  description = "A list of email addresses used for sending connection update notifications."
  default = ["example@equinix.com"]
}

variable "fabric_destination_metro_code" {
  type        = string
  description = "Destination Metro code where the connection will be created."
  default     = "SV" // Corresponds to Silicon Valley
}

variable "fabric_speed" {
  type        = number
  description = <<EOF
  Speed/Bandwidth in Mbps to be allocated to the connection. If unspecified, it will be used the minimum
  bandwidth available for the `Equinix Metal` service profile. Valid values are
  (50, 100, 200, 500, 1000, 2000, 5000, 10000).
  EOF
  default     = 50
}

variable "redundancy_type" {
  type        = string
  description = "Whether to create a 'SINGLE' connection or 'REDUNDANT'."
  default     = "REDUNDANT"
}

variable "platform" {
  type        = string
  description = <<EOF
  (Required) Platform this terraform module will run on. One of: linux, darwin.
  
  NOTE: Configuration of the bgp customer ASN in google side is not directly supported with current google terraform
  provider (v3.72.0). As a workaround this module take advantage of 'terraform-google-gcloud' module which allows use
  gcloud. However, it is only available for `linux` and `darwin` based operating systems.
  EOF
}
