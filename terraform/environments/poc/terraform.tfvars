api_url = "https://compute.jp-east.idcfcloud.com/client/api"

zone = "tesla"

network_id = "b1cb5ec4-3860-4bbe-b651-a21f60521e6b"

keypair = "n-tanaka"

instances = {
  "homelab-workstation-01" = {
    service_offering = "standard.M8"
    root_disk_size   = 50
  }
}

disks = {
}

nat_instances = {
  "homelab-workstation-01" = true
}

template = "Rocky Linux 9.4 64-bit"

firewall_rules = {
  "homelab-workstation-01" = {
    cidr_list = ["202.230.223.225/32", "202.230.240.74/32"]
    protocol  = "tcp"
    ports     = [22]
  }
}
