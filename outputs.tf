output "fabric_connection_uuid" {
  description = "Unique identifier of the connection."
  value       = module.equinix-fabric-connection.primary_connection.uuid
}

output "fabric_connection_name" {
  description = "Name of the connection."
  value       = module.equinix-fabric-connection.primary_connection.name
}

output "fabric_connection_status" {
  description = "Connection provisioning status."
  value       = module.equinix-fabric-connection.primary_connection.status
}

output "fabric_connection_provider_status" {
  description = "Connection provisioning provider status."
  value       = module.equinix-fabric-connection.primary_connection.provider_status
}

output "fabric_connection_speed" {
  description = "Connection speed."
  value       = module.equinix-fabric-connection.primary_connection.speed
}

output "fabric_connection_speed_unit" {
  description = "Connection speed unit."
  value       = module.equinix-fabric-connection.primary_connection.speed_unit
}

output "fabric_connection_seller_metro" {
  description = "Connection seller metro code."
  value       = module.equinix-fabric-connection.primary_connection.seller_metro_code
}

output "fabric_connection_seller_region" {
  description = "Connection seller region."
  value       = module.equinix-fabric-connection.primary_connection.seller_region
}

output "gcp_interconnect_id" {
  description = "Google Cloud Interconnect/VLAN attachment ID."
  value = google_compute_interconnect_attachment.this.id
}

output "gcp_cloud_router_id" {
  description = "Google Cloud Router ID."
  value = local.gcp_compute_router_id
}

output "gcp_cloud_router_ip_address" {
  description = <<EOF
  Google Cloud Router IPv4 address + prefix length to be configured on Cloud Router Interface for the interconnect
  attachment.
  EOF
  value = google_compute_interconnect_attachment.this.cloud_router_ip_address
}

output "gcp_customer_router_ip_address" {
  description = <<EOF
  Google Cloud Router IPv4 address + prefix length to be configured on customer router or Network Edge device subinterface for
  the interconnect attachment.
  EOF
  value = google_compute_interconnect_attachment.this.customer_router_ip_address
}
