variable "db_name" {
  type        = string
  description = "Name of the psql database."
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "username" {
  type        = string
  default     = "lovage"
  description = "DB Admin username"
}

variable "password" {
  type        = string
  description = "DB Admin password"
}
