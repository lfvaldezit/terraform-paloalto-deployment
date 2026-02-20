variable "ami_id" {
  description = "AMI ID for the instance"
  type = string
}

variable "instance_type" {
  description = "Instance type for the instance"
  type = string
}

variable "security_group_ids" {
  description = "Security Group ID for the instance"
  type = set(string)
  default = [ ]
}

variable "name" {
  description = "Base name prefix used to label all created resources"
  type = string
}

variable "subnet_id" {
  description = "Default Subnet ID"
  type        = string
  default     = null
}

# variable "private_subnet_id" {
#   description = "Private subnet ID"
#   type        = list(string)
#   default     = []
# }

variable "user_data" {
  description = "User data script for the instance"
  type = string
  default = null
}

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
}

variable "source_dest_check" {
  description = "Blocks traffic if the instance isn't the source or destination"
  type = string
}

# variable "instance_count" {
#   description = "Number of EC2 instances to be created"
#   type = string
# }

# variable "enable_public_eni" {
#   description = "Create public ENI"
#   type = bool
# }

# --------------------------------------------------------

variable "enable_mgmt_eni" {
  type = bool
  default = false
}

variable "mgmt_subnet_id" {
  description = "Mgmt subnet ID"
  type = string
  default     = null  
}

variable "security_group_mgmt_ids" {
  description = "Security Group ID for the instance"
  type = set(string)
  default = []
}

variable "enable_inside_eni" {
  type = bool
  default = false
}

variable "inside_subnet_id" {
  description = "Inside subnet ID"
  type = string
  default     = null  
}

variable "security_group_inside_ids" {
  description = "Security Group ID for the instance"
  type = set(string)
  default = []
}

variable "enable_outside_eni" {
  type = bool
  default = false
}

variable "outside_subnet_id" {
  description = "Outside subnet ID"
  type = string
  default = null
}

variable "security_group_outside_ids" {
  description = "Security Group ID for the instance"
  type = set(string)
  default = []
}

variable "key_name" {
  type = string
  default = null
}

variable "multi_eni" {
  type = bool
}
