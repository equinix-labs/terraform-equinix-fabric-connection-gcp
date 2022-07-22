output "connection_primary_details" {
  value = module.equinix-fabric-connection-gcp-primary
}

output "connection_secondary_details" {
  value = var.redundancy_type == "REDUNDANT" ? module.equinix-fabric-connection-gcp-secondary : null
}
