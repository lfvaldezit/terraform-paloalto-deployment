variable "name" {
  description = "Name for all resources"
  type        = string
}

#----------------------------
# VPC Variables
#----------------------------

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "outside_subnets" {
  description = "List of outside subnets"
  default     = []
  type = list(object({
    name       = string
    cidr_block = string
    az         = string
  }))
}

variable "inside_subnets" {
  description = "List of inside subnets"
  default     = []
  type = list(object({
    name       = string
    cidr_block = string
    az         = string
  }))
}

variable "management_subnets" {
  description = "List of mgmt subnets"
  default     = []
  type = list(object({
    name       = string
    cidr_block = string
    az         = string
  }))

}

variable "spare_subnets" {
  description = "List of spare subnets"
  default     = []
  type = list(object({
    name       = string
    cidr_block = string
    az         = string
  }))
}

variable "create_igw" {
  type    = bool
  default = false
}

#----------------------------
# Security Groups Variables
#----------------------------

variable "description_outside" {
  type = string
}

variable "ingress_rules_outside" {
  description = "List of outside rules"
  type = list(object({
    source   = string
    fromPort = number
    toPort   = number
    protocol = string
  }))
  default = []
}

variable "security_groups_outside" {
  type = map(object({
    description = optional(string, "")
    vpc_id      = optional(string, null)
    inbound = optional(list(object({
      protocol    = optional(string, "-1")
      ports       = optional(string, null)
      source      = string
      description = optional(string, "")
    })), [])
    outbound = optional(list(object({
      protocol    = optional(string, "-1")
      ports       = optional(string, null)
      destination = string
      description = optional(string, "")
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "description_inside" {
  type = string
}

variable "ingress_rules_inside" {
  description = "List of inside rules"
  type = list(object({
    source   = string
    fromPort = number
    toPort   = number
    protocol = string
  }))
  default = []
}

variable "security_groups_inside" {
  type = map(object({
    description = optional(string, "")
    vpc_id      = optional(string, null)
    inbound = optional(list(object({
      protocol    = optional(string, "-1")
      ports       = optional(string, null)
      source      = string
      description = optional(string, "")
    })), [])
    outbound = optional(list(object({
      protocol    = optional(string, "-1")
      ports       = optional(string, null)
      destination = string
      description = optional(string, "")
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}


variable "description_mgmt" {
  type = string
}

variable "ingress_rules_mgmt" {
  description = "List of mgmt rules"
  type = list(object({
    source   = string
    fromPort = number
    toPort   = number
    protocol = string
  }))
  default = []
}

variable "security_groups_mgmt" {
  type = map(object({
    description = optional(string, "")
    vpc_id      = optional(string, null)
    inbound = optional(list(object({
      protocol    = optional(string, "-1")
      ports       = optional(string, null)
      source      = string
      description = optional(string, "")
    })), [])
    outbound = optional(list(object({
      protocol    = optional(string, "-1")
      ports       = optional(string, null)
      destination = string
      description = optional(string, "")
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}


variable "description_spare" {
  type = string
}

variable "ingress_rules_spare" {
  description = "List of spare rules"
  type = list(object({
    source   = string
    fromPort = number
    toPort   = number
    protocol = string
  }))
  default = []
}

variable "security_groups_web" {
  type = map(object({
    description = optional(string, "")
    #vpc_id      = optional(string, null)
    inbound = optional(list(object({
      protocol    = optional(string, "-1")
      ports       = optional(string, null)
      source      = string
      description = optional(string, "")
    })), [])
    outbound = optional(list(object({
      protocol    = optional(string, "-1")
      ports       = optional(string, null)
      destination = string
      description = optional(string, "")
    })), [])
    tags = optional(map(string), {})
  }))
  default = {}
}


#----------------------------
# EC2 Variables
#----------------------------

# variable "instance_count" {
#   type = string
# }

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "source_dest_check" {
  type = bool
}

# variable "enable_mgmt_eni" {
#   type = bool
# }

# variable "enable_inside_eni" {
#   type = bool
# }

# variable "enable_outside_eni" {
#   type = bool
# }

variable "fw1_instance_type" {
  type = string
}

variable "fw1_ami_id" {
  type = string
}

variable "fw1_source_dest_check" {
  type = bool
}

variable "fw1_enable_mgmt_eni" {
  type = bool
}

variable "fw1_enable_inside_eni" {
  type = bool
}

variable "fw1_enable_outside_eni" {
  type = bool
}



