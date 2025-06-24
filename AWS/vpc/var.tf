variable "vpc_parameters" {
  description = "VPC parameters"
  type = map(object({
    cidr_block           = string
    enable_dns_support   = optional(bool, true)
    enable_dns_hostnames = optional(bool, true)
    tags                 = optional(map(string), {})
  }))
  default = {}
}


variable "subnet_parameters" {
  description = "Subnet parameters"
  type = map(object({
    cidr_block               = string
    vpc_name                 = string
    availability_zone        = string
    map_public_ip_on_launch  = optional(bool, false)
    tags                     = optional(map(string), {})
  }))
  default = {}
}

variable "igw_parameters" {
  description = "IGW parameters"
  type = map(object({
    vpc_name = string
    tags     = optional(map(string), {})
  }))
  default = {}
}


variable "rt_parameters" {
  description = "RT parameters"
  type = map(object({
    vpc_name = string
    tags     = optional(map(string), {})
    routes = optional(list(object({
      cidr_block = string
      use_igw    = optional(bool, true)
      gateway_id = string
    })), [])
  }))
  default = {}
}
variable "rt_association_parameters" {
  description = "RT association parameters"
  type = map(object({
    subnet_name = string
    rt_name     = string
  }))
  default = {}
}

variable "nat_gateway_parameters" {
  description = "NAT Gateway parameters"
  type = map(object({
    subnet_name = string
    tags        = optional(map(string), {})
  }))
  default = {}
}

variable "flow_log_parameters" {
  description = "VPC Flow Logs parameters"
  type = map(object({
    vpc_name             = string
    traffic_type         = optional(string, "ALL")
    log_destination      = string
    log_destination_type = optional(string, "s3")
    tags                 = optional(map(string), {})
  }))
  default = {}
}
