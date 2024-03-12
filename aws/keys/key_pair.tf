resource "random_uuid" "key_name" {
  keepers = {
    always_same = "static-value"
  }
}

variable "pubkey_file" {
  description = "Public key file path"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

resource "aws_key_pair" "authorized_key" {
  key_name   = random_uuid.key_name.result
  public_key = file(var.pubkey_file)
}

output "key_name" {
  value = random_uuid.key_name.result
}
