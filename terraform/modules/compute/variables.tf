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

  validation {
    condition = alltrue([
      for vm_name in keys(var.disks) : contains(keys(var.instances), vm_name)
    ])
    error_message = "All keys in var.disks must exist in var.instances. Invalid VM names found in disks configuration."
  }
}

variable "nat_instances" {
  description = "Set of instance names that need NAT and IP"
  type        = set(string)
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

  validation {
    condition = alltrue([
      for vm_name in keys(var.firewall_rules) : contains(var.nat_instances, vm_name)
    ])
    error_message = "All keys in var.firewall_rules must exist in var.nat_instances. Firewall rules can only be created for instances with NAT configured."
  }
}

variable "expunge" {
  description = "Whether to expunge VMs on destroy. Set to true for permanent deletion (destructive). Default is false for safety."
  type        = bool
  default     = false
}
