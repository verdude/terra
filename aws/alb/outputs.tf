output "lb_dns_name" {
  value = aws_lb.public_alb.dns_name
}

output "lb_arn" {
  value = aws_lb.public_alb.arn
}

output "lb_id" {
  value = aws_lb.public_alb.id
}

output "lb_zone_id" {
  value = aws_lb.public_alb.zone_id
}
