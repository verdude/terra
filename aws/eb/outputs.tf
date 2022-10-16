output "load_balancer_arns" {
  value = aws_elastic_beanstalk_environment.beanstalkappenv.load_balancers
}

output "load_balancer_ids" {
  value = aws_elastic_beanstalk_environment.beanstalkappenv.load_balancers
}

output "wholething" {
  value = aws_elastic_beanstalk_environment.beanstalkappenv
}
