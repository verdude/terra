resource "aws_lb" "public_alb" {
  name = var.name
  internal = false
  load_balancer_type = "application"
  security_groups = var.sec_groups
  subnets = var.subnets

  enable_deletion_protection = var.protected

  tags = {
    Name = var.name
  }
}

resource "aws_lb_target_group" "target_group" {
  name = "targetpoop"
  port = var.port
  protocol = "HTTP"
  vpc_id = var.vpc_id

  tags = {
    Name = "Publicgroup"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port = var.port
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "main_target" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id = var.instance_id
  port = var.port
}
