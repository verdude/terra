locals = {
  acl_associations = distinct(flatten([
    for acl in aws_wafv2_web_acl.managed_acl : [
      for resource_arn in var.resource_arns : {
        acl_arn = acl.arn
        resource_arn = resource_arn
      }
    ]
  ]))
}

resource "aws_wafv2_web_acl" "waf_web_acl" {
  for_each = var.managed_rule_groups
  name = "waf_acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name = each.key
    priority = each.value["priority"]

    override_action {
      # just use managed rule group action
      none {}
    }

    statement {
      managed_rule_group_statement {
        name = each.value["statement"]["name"]
        vendor_name = each.value["statement"]["vendor_name"]

        dynamic "excluded_rule" {
          for_each = each.value["statement"]["excluded_rules"]
          content {
            name = excluded_rule.value
          }
        }
      }
    }

    visibility_config {
      metric_name = "default-${each.key}"
      cloudwatch_metrics_enabled = false
      sampled_requests_enabled = false
    }
  }

  visibility_config {
    metric_name = "default"
    cloudwatch_metrics_enabled = false
    sampled_requests_enabled = false
  }
}

resource "aws_wafv2_web_acl_association" "associations" {
  for_each = local.acl_associations
  resource_arn = each.value.resource_arn
  web_acl_arn = each.value.acl_arn
}
