terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "api" {
  provisioner "remote-exec" {
    inline = [
      "sudo useradd -m erra",
      "sudo usermod -aG wheel erra",
      "echo %wheel ALL=(ALL) ALL | sudo tee -a /etc/sudoers"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("yourkey.pem")}"
    }
  }

  provisioner "file" {
    source      = "authorized_keys"
    destination = "/home/erra/.ssh/authorized_keys"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("yourkey.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chown someuser:someuser /home/someuser/.ssh/authorized_keys",
      "sudo chmod 0600 /home/someuser/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("yourkey.pem")}"
    }
  }

  ami = "ami-08970fb2e5767e3b8"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
