variable "vpc_id" {
  type = string
}

variable "security_groups" {
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

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
  default = {}
}