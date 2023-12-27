data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-12-amd64-20231013-1532"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["136693071363"]
}

// resources
module "vpc" {
  source = "../../aws/vpc/main"

  az = "us-west-2a"
  az2 = "us-west-2b"
}

module "sec_groups" {
  source = "../../aws/sec_groups"
  vpc_id = module.vpc.vpc_id
}

module "keys" {
  source   = "../../aws/keys"
  key_name = uuid()
}

module "ec2" {
  source = "../../aws/ec2"

  vpc_sec_gids = module.sec_groups.sec_group_ids
  vpc_id       = module.vpc.vpc_id
  key_name     = module.keys.key_name
  ami          = data.aws_ami.debian.id
  subnet_id    = module.vpc.p_subnet_id
  igw          = module.vpc.igw
  size         = "t3.nano"
}
