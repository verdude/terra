output "lb_arns" {
  value = module.eb.load_balancer_arns
}

output "ebe" {
  value = module.eb.wholething
}
