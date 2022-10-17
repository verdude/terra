variable "acl_name" {
  type = string
  description = "Friendly name for the ACL"
}

variable "associated_arns" {
  type = map(string)
  description = "List of arns to attach associate with the WAF"
}

variable "managed_rule_groups" {
  description = "List of managed rule groups with settings"
  type = map(object({
    priority = number
    action = optional(string, "")

    statement = object({
      name = string
      vendor_name = optional(string, "AWS")
      excluded_rules = optional(set(string), [])
    })
  }))

  default = {}
}
