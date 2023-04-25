data "aws_instance" "eb_instance" {
  instance_id = module.eb.instances[0]
}

resource "random_pet" "key-name" {
  length    = 2
  separator = "-"
}

resource "random_pet" "eb-app-name" {
  length    = 2
  separator = "-"
}

data "aws_vpc" "default" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "key" {
  source   = "../../aws/keys"
  key_name = random_pet.key-name.id
}

resource "aws_elastic_beanstalk_application" "wowee" {
  name = random_pet.eb-app-name.id
}

module "priv_sec_groups" {
  source = "../../aws/sec_groups/priv"
  vpc_id = data.aws_vpc.default.id
}

module "sec_groups" {
  source = "../../aws/sec_groups"
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

module "ec2" {
  source = "../../aws/ec2"

  vpc_sec_gids = module.sec_groups.sec_group_ids
  vpc_id       = data.aws_vpc.default.id
  key_name     = module.key.key_name
  ami          = data.aws_ami.ubuntu.id
  subnet_id    = data.aws_subnets.default.ids[0]
  igw          = data.aws_internet_gateway.default.id
  size         = "t2.medium"
}

module "eb" {
  source = "../../aws/eb"

  internal_elb = {
    vpc_id      = data.aws_vpc.default.id
    subnets     = slice(data.aws_subnets.default.ids, 0, 1)
    elb_subnets = data.aws_subnets.default.ids
  }

  tier                = "WebServer"
  solution_stack_name = "64bit Amazon Linux 2 v3.5.6 running Docker"
  elasticapp          = aws_elastic_beanstalk_application.wowee.name
  beanstalkappenv     = "production"
  iam_role_name       = aws_iam_instance_profile.test_profile.name
  ec2_key_name        = module.key.key_name
  sec_groups          = module.priv_sec_groups.sec_group_ids

  deployment_policy             = "RollingWithExtraBatch"
  rolling_update_type           = "Time"
  pause_time                    = "PT0S"
  rolling-update-max-batch-size = 2
  rolling-update-min-instances  = 1
  deregistration_delay          = 10

  depends_on = [module.sec_groups]
}

output "lb" {
  value = module.eb.load_balancers
}

output "ebid" {
  value = module.eb.id
}

output "ebec2" {
  value = module.eb.instances
}
