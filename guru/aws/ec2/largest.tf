variable "vpc_sec_gids" {
  description = "The VPC Security Group ids for the ec2 instance."
  type = list(number)
  nullable = false
}

variable "key_name" {
  description = "The name of an aws key pair to authorize."
  nullable = false
  type = string
}

variable "ami" {
  description = "The ec2 ami."
  type = string
  nullable = false

  default = "ami-017fecd1353bcc96e"
}

variable "size" {
  description = "Instance type. default: t3.medium"
  nullable = false
  type = string

  default = "t3.medium"
}

resource "aws_instance" "largest-guru-ec2" {
  ami = var.ami
  instance_type = var.size
  key_name = var.key_name

  vpc_security_group_ids = var.vpc_sec_gids
}
