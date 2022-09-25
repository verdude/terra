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

// resources
module "vpc" {
  source = "./sec_groups/allow_all"
}

module "key" {
  source = "./keys/key_pair"
}

module "ec2" {
  source = "./guru/aws/ec2/largest"

  vpc_sec_gids = [module.vpc.aws_security_group.allow_all.id]
  key_name = module.key.key_name
  ami = data.aws_ami.ubuntu.id
  size = "t3.medium"
}

// outputs
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
