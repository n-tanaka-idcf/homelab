output "instances" {
  value = cloudstack_instance.rancher
}

output "ip_addresses" {
  value = {
    for k, ip in cloudstack_ipaddress.rancher :
    k => ip.ip_address
  }
}
