variable "vpc_id" {
  description = "vpc for the security group"
  type        = string
  nullable    = false
}

resource "random_pet" "group-name" {
  length    = 2
  separator = "-"
}

resource "aws_security_group" "egress_only" {
  name        = random_pet.group-name.id
  description = "egress only"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "egress_only"
  }
}

output "sec_groups" {
  value = [aws_security_group.egress_only]
}

output "sec_group_ids" {
  value = [aws_security_group.egress_only.id]
}
