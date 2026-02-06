variable "instances" {
  description = "Map of instance configurations"
  type = map(object({
    service_offering = string
    root_disk_size   = number
  }))
}

variable "disks" {
  description = "Map of additional disks per instance"
  type = map(list(object({
    size = number
  })))
}

variable "nat_instances" {
  description = "Map of instances that need NAT and IP"
  type        = map(bool)
}

variable "zone" {
  type = string
}

variable "network_id" {
  type = string
}

variable "keypair" {
  type = string
}

variable "template" {
  type = string
}

variable "firewall_rules" {
  type = map(object({
    cidr_list = list(string)
    protocol  = string
    ports     = list(number)
  }))
}
