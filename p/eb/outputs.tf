output "ec2_public_ip" {
  value = data.aws_instance.eb_instance.public_ip
}
