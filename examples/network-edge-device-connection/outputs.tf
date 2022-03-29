output "fabric_connection_id" {
  value = module.equinix-fabric-connection-gcp.fabric_connection_uuid
}

output "fabric_connection_name" {
  value = module.equinix-fabric-connection-gcp.fabric_connection_name
}

output "fabric_connection_status" {
  value = module.equinix-fabric-connection-gcp.fabric_connection_status
}

output "fabric_connection_provider_status" {
  value = module.equinix-fabric-connection-gcp.fabric_connection_provider_status
}

output "network_edge_bgp_provisioning_status" {
  description = "Network Edge device BGP peering configuration provisioning status."
  value       = module.equinix-fabric-connection-gcp.network_edge_bgp_provisioning_status
}

output "gcp_interconnect_id" {
  description = "Google Cloud Interconnect/VLAN attachment ID."
  value       = module.equinix-fabric-connection-gcp.gcp_interconnect_id
}

output "gcp_cloud_router_id" {
  description = "Google Cloud Router ID."
  value       = module.equinix-fabric-connection-gcp.gcp_cloud_router_id
}
