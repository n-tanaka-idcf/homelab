variable "api_url" {
  type = string
}

variable "api_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "network_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "keypair" {
  type = string
}

variable "instances" {
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
  type = map(bool)
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
  default = {}
}
