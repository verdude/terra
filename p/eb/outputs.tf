output "ec2-ip" {
  value = data.aws_instance.eb_instance.public_ip
}
