resource "aws_waf_web_acl" "waf_web_acl" {
  name = "waf_acl"

  default_action {
    type = "ALLOW"
  }

  dynamic "rule" {
    for_each = var.managed_rule_groups
    content {
      name = rule.value["name"]
      override_action = rule.value["override_action"]
      priority = rule.value["priority"]
      statement = rule.value["statement"]
    }
  }
}
