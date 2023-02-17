variable "vpc_id" {
  description = "vpc for the security group"
  type        = string
  nullable    = false
}

resource "aws_security_group" "allow_all" {
  name        = "allow all"
  description = "allow all"
  vpc_id      = var.vpc_id

  ingress {
    description      = "all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

output "sec_group_ids" {
  value = [aws_security_group.allow_all.id]
}
