output "access_ip_address" {
  value = module.compute.ip_addresses["homelab-workstation-01"]
}
