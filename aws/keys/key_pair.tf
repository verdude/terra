variable "key_name" {
  type = string
  default = "default_key"
}

variable "pubkey_file" {
  description = "Public key file path"
  type = string
  default = "~/.ssh/id_ed25519.pub"
}

resource "aws_key_pair" "authorized_key" {
  key_name = var.key_name
  public_key = file(var.pubkey_file)
}

output "key_name" {
  value = var.key_name
}
