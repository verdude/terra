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

variable "internal_elb" {
  type = object({
    vpc_id      = string
    subnets     = list(string)
    elb_subnets = list(string)
  })

  default = null

  validation {
    condition     = (var.internal_elb == null) || (try(length(var.internal_elb.subnets), 0) > 0 && try(length(var.internal_elb.elb_subnets), 0) > 0)
    error_message = "internal_elb must be set if you want to create an internal elb, and both subnets and elb_subnets must be non-empty lists."
  }

  validation {
    # VPC is not null if internal_elb is true
    condition     = (var.internal_elb == null) || (try(var.internal_elb.vpc_id != null && var.internal_elb.vpc_id != "", false))
    error_message = "vpc_id must be set if you want to create an internal elb and cannot be empty."
  }
}

variable "sec_groups" {
  type        = list(string)
  description = "sec groups"
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
  default     = "Health"
}

variable "pause_time" {
  type        = string
  description = "Pause time between batches"
  default     = "PT3S"
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
