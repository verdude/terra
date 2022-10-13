output "acl_arn" {
  value = [
    for acl in aws_wafv2_web_acl.waf_web_acl : acl.arn
  ]
}
