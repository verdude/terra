teerraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

variable "key_name" {
  type = string
  default = "erra"
}

resource "aws_security_group" "allow_all" {
  name        = "allow all"
  description = "allow all"

  ingress {
    description = "all"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_key_pair" "authorized_key" {
  key_name = var.key_name
  public_key = file("/home/erra/.ssh/id_ed25519.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "api" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.size
  key_name = aws_key_pair.authorized_key.key_name

  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name = "api"
  }
}

output "arn" {
  value = aws_instance.api.arn
}

output "instance_state" {
  value = aws_instance.api.instance_state
}

output "pw" {
  value = aws_instance.api.password_data
}

output "public_ip" {
  value = aws_instance.api.public_ip
}
