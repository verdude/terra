resource "aws_wafv2_web_acl" "managed_acl" {
  name  = "managed_waf_acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = var.managed_rule_groups
    content {
      name     = rule.key
      priority = rule.value["priority"]

      override_action {
        # just use managed rule group action
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value["statement"]["name"]
          vendor_name = rule.value["statement"]["vendor_name"]

          dynamic "excluded_rule" {
            for_each = rule.value["statement"]["excluded_rules"]
            content {
              name = excluded_rule.value
            }
          }
        }
      }

      visibility_config {
        metric_name                = "default-${rule.key}"
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  }

  visibility_config {
    metric_name                = "default"
    cloudwatch_metrics_enabled = false
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "associations" {
  for_each = var.associated_arns

  resource_arn = each.value
  web_acl_arn  = aws_wafv2_web_acl.managed_acl.arn
}
