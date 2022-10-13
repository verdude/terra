variable "acl_name" {
  type = string
  description = "Friendly name for the ACL"
}

variable "region" {
  type = string
  description = "The AWS Region"
}

variable "resource_arn" {
  type = string
  description = "arn of the target lb or other supported resource"
}

variable "managed_rule_groups" {
  description = "Map of managed rule groups with settings"
  type = list(object({
    name = string
    override_action = string
    priority = number

    statement = object({
      name = string
      vendor_name = optional(string, "AWS")
      excluded_rule = optional(list(string))
    })
  }))
}
