output "lb_dns_name" {
  value = aws_lb.public_alb.dns_name
}

output "lb_arn" {
  value = aws_lb.public_alb.arn
}
