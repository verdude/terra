terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.21"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.4"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
