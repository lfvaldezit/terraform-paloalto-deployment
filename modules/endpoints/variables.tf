variable "subnet_id" {
  description = "Subnet ID in which to create the endpoint"
  type = string
}

variable "security_group_ids" {
  description = "Security Group ID for the endpoint"
  type = set(string)
}

variable "name" {
  description = "Base name prefix used to label all created resources"
  type = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
}
