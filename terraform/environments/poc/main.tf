module "compute" {
  source = "../../modules/compute"

  instances      = var.instances
  disks          = var.disks
  zone           = var.zone
  network_id     = var.network_id
  keypair        = var.keypair
  template       = var.template
  nat_instances  = var.nat_instances
  firewall_rules = var.firewall_rules

  providers = {
    cloudstack = cloudstack
  }
}
