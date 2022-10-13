variable "sec_groups" {
  description = "security groups"
  type = list(string)
}

variable "subnets" {
  description = "subnets"
  type = list(string)
}

variable "name" {
  description = "friendly name"
  type = string
}

variable "protected" {
  type = bool
  description = "Determines whether deletion protection is enabled"

  default = false
}

variable "vpc_id" {
  type = string
  description = "Vpc id for target group"
}

variable "instance_id" {
  description = "ec2 id"
  type = string
}

variable "port" {
  description = "port for service running on ec2"
  type = number
}
