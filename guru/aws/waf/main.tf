resource "aws_wafv2_web_acl" "waf_web_acl" {
  name = "waf_acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = var.managed_rule_groups
    content {
      name = rule.value["name"]
      priority = rule.value["priority"]

      action {
        dynamic "block" {
          for_each = rule.value["action"] == "block" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value["action"] == "count" ? [1] : []
          content {}
        }

        dynamic "allow" {
          for_each = rule.value["action"] == "allow" ? [1] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          name = rule.value["statement"]["name"]
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
        metric_name = "default-${rule.value["name"]}"
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled = false
      }
    }
  }

  visibility_config {
    metric_name = "default"
    cloudwatch_metrics_enabled = false
    sampled_requests_enabled = false
  }

  depends_on = [var.target_id]
}

resource "aws_wafv2_web_acl_association" "example" {
  resource_arn = var.resource_arn
  web_acl_arn = aws_wafv2_web_acl.waf_web_acl.arn
}
