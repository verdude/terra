output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "password" {
  value = module.ec2.pw
}

output "ec2_state" {
  value = module.ec2.instance_state
}

output "ec2_arn" {
  value = module.ec2.arn
}

output "alb_ds" {
  value = module.alb.lb_dns_name
}
