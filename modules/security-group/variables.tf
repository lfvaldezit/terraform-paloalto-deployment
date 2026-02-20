
variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "security_group_description" {
  description = "Description of the security group"
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    source = string
    fromPort    = number
    toPort      = number
    protocol    = string
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    destination = string
    fromPort    = number
    toPort      = number
    protocol    = string
  }))
  default = []
}

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
  default = {}
}