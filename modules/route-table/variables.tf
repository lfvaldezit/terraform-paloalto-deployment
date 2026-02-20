variable "name" {
  type = string
}

variable "vpc_id" {
    type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
  default = {}
}

variable "routes" {
  description = "List of routes with their destination and next-hop configurations"
  type = list(object({
    destination_cidr = string
    next_hop_type = string # transit_gateway, internet_gateway, network_interface
    next_hop_id = string 
  }))
  default = []
}