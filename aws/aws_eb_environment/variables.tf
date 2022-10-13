variable "application_name" {
  type        = string
  description = "The name of the parent application in which the environments will be stored."
}

variable "application_environment_variables" {
  type        = map(any)
  description = "The system environment variables that the environment will need to function"
}

variable "certificate_arn" {
  type        = string
  description = "AWS Certificate ARN for setting up ALB HTTP to HTTPS load balancing"
}

variable "datadog_enabled" {
  type        = bool
  description = "Whether or not to enable Datadog monitoring for the environment."
  default     = false
}

variable "deregistration_delay" {
  type        = number
  description = "Amount of time, in seconds, to wait for active requests to complete before deregistering. Used in combination with Application Load Balancer."
  default     = 20
}

variable "environment_solution_stack_name" {
  type        = string
  description = "The software/language that the environment will run on."
}

variable "environment_name" {
  type        = string
  description = "The name of the EB environment."
}

variable "environment_description" {
  type        = string
  description = "The description of what the environment is."
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type for an EB environment."
}
variable "route53_record_url_prefix" {
  type        = string
  description = "The url that will preappended onto the DNS namespace where the environment will be found. (ex. our namepsace is 'lovage.dev' so if the prefix were 'phone' you would find the environment at 'phone.lovage.dev')"
}

variable "route53_zone_name" {
  type        = string
  description = "A hosted zone is an Amazon Route 53 concept. A hosted zone is analogous to a traditional DNS zone file; it represents a collection of records that can be managed together, belonging to a single parent domain nam"
}


variable "security_groups" {
  type        = list(string)
  description = "The security groups that will be used for the EB environment in addition to the default one."
  default     = []
}

variable "settings" {
  type        = list(map(any))
  description = "Any other settings that you want to set on the EB environment."
  default     = []
}


variable "tags" {
  type        = map(string)
  description = "Any tags that you want to set on the EB environment."
  default     = {}
}

variable "deployment_policy" {
  type        = string
  description = "Rolling, Immutable, Traffic Splitting etc."
  default     = "Immutable"
}

variable "autoscale_min" {
  type        = string
  description = "Minimum number of instances to run"
  default     = 1
}

variable "autoscale_max" {
  type        = string
  description = "Maximum number of instances to run"
  default     = 10
}

variable "autoscale_measure_name" {
  type        = string
  description = "Name of the measure to use for autoscaling (i.e. TargetResponseTime, Latency, etc.)"
  default     = "NetworkOut"
}

variable "autoscale_statistic" {
  type        = string
  description = "Average, Min, Max, Sum etc."
  default     = "Average"
}

variable "autoscale_unit" {
  type        = string
  description = "How to measure the 'autoscale_measure_name' (i.e. Seconds, Bytes, Count etc.)"
  default     = "Bytes"
}

variable "autoscale_lower_bound" {
  type        = string
  description = "Threshold for scaling down"
  default     = "2000000"
}

variable "autoscale_lower_increment" {
  type        = string
  description = "Number of instances to scale down by"
  default     = "-1"
}

variable "autoscale_upper_bound" {
  type        = string
  description = "Number of instances to scale up by"
  default     = "6000000"
}

variable "autoscale_upper_increment" {
  type        = string
  description = "Threshold for scaling up"
  default     = "1"
}
