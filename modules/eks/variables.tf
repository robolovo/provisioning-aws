variable "name" {
  description = "Name to be used on EKS cluster created"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "The VPC Subnet ID to launch in"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "security_group_ids" {
  description = "A list of security groups"
  type        = list(string)
  default     = []
}