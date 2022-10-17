variable "acl_name" {
  type = string
  description = "Friendly name for the ACL"
}

variable "resource_arns" {
  type = list(string)
  description = "list of the target lb or other supported resource arns"
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
