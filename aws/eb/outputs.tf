output "load_balancers" {
  value = aws_elastic_beanstalk_environment.beanstalkappenv.load_balancers
}

output "id" {
  value = aws_elastic_beanstalk_environment.beanstalkappenv.id
}

output "instances" {
  value = aws_elastic_beanstalk_environment.beanstalkappenv.instances
}
