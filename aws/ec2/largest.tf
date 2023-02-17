variable "vpc_sec_gids" {
  description = "The VPC Security Group ids for the ec2 instance."
  type        = list(string)
  nullable    = false
}

variable "vpc_id" {
  description = "vpc for ec2 instance"
  type        = string
  nullable    = false
}

variable "key_name" {
  description = "The name of an aws key pair to authorize."
  type        = string
  nullable    = false
}

variable "ami" {
  description = "The ec2 ami."
  type        = string
  nullable    = false

  default = "ami-017fecd1353bcc96e"
}

variable "size" {
  description = "Instance type. default: t3.medium"
  type        = string
  nullable    = false

  default = "t3.medium"
}

variable "subnet_id" {
  description = "ec2 subnet"
  type        = string
  nullable    = false
}

variable "igw" {
  description = "dependencies"
}

resource "aws_instance" "default" {
  ami           = var.ami
  instance_type = var.size
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids      = var.vpc_sec_gids
  associate_public_ip_address = true

  depends_on = [var.igw]
}

output "arn" {
  value = aws_instance.default.arn
}

output "instance_state" {
  value = aws_instance.default.instance_state
}

output "pw" {
  value = aws_instance.default.password_data
}

output "public_ip" {
  value = aws_instance.default.public_ip
}

output "id" {
  value = aws_instance.default.id
}
