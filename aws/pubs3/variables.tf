variable "environment" {
  description = "The name of the environment. The bucket name will include this value."
  type        = string
}

variable "object_name" {
  description = "Type of object that will go in the bucket."
  type        = string
}

variable "folder" {
  description = "Name of the folder to create in the bucket."
  type        = string
}
