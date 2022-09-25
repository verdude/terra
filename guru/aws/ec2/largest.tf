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

  ami = "ami-017fecd1353bcc96e"
  instance_type = "t3.medium"

  tags = {
    Name = "guruec2"
  }
}
