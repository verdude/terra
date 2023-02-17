variable "elasticapp" {
  default = "myapp"
}
variable "beanstalkappenv" {
  default = "myenv"
}
variable "solution_stack_name" {
  type = string
}
variable "tier" {
  type = string
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "public_subnets" {
  type        = list(string)
  description = "public subnets for the EC2"
}

variable "elb_public_subnets" {
  type        = list(string)
  description = "Subnets for the ALB"
}

variable "iam_role_name" {
  type = string
}

variable "ec2_key_name" {
  type        = string
  description = "name of the key to add to the ec2"

  default = ""
}

variable "deregistration_delay" {
  type        = number
  description = "Amount of time, in seconds, to wait for active requests to complete before deregistering. Used in combination with Application Load Balancer."
  default     = 20
}

variable "deployment_policy" {
  type        = string
  description = "Rolling, Immutable, Traffic Splitting etc."
  default     = "Rolling"
}

variable "rolling_update_type" {
  type        = string
  description = "Health | Time | Immutable. Immutable is safest."
  default     = "Immutable"
}

variable "rolling-update-min-instances" {
  type        = string
  description = "Disabled, Rolling based on Time, Rolling based on Health, Immutable etc."
  default     = 1
}

variable "rolling-update-max-batch-size" {
  type        = string
  description = "Max Batch size for rolling updates"
  default     = 1
}
