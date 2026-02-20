variable "name" {
  description = "Name for all resources"
  type = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
}

variable "outside_subnets" {
  description = "List of outside subnets"
  default = []
  type = list(object({
    name                  = string
    cidr_block            = string
    az                    = string
  }))
}

variable "inside_subnets" {
  description = "List of inside subnets"
  default = []
  type = list(object({
    name                  = string
    cidr_block            = string
    az                    = string
  }))
}

variable "management_subnets" {
  description = "List of mgmt subnets"
  default = []
  type = list(object({
    name                  = string
    cidr_block            = string
    az                    = string
  }))

}

variable "spare_subnets" {
  description = "List of spare subnets"
  default = []
  type = list(object({
    name                  = string
    cidr_block            = string
    az                    = string
  }))
}

variable "create_igw" {
  type = bool
  default = false
}
