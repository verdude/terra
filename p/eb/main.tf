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

module "vpc" {
  source = "../../aws/vpc/main"
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
  vpc_id = module.vpc.vpc_id

  depends_on = [module.vpc.vpc_id]
}

module "sec_groups" {
  source = "../../aws/sec_groups"
  vpc_id = module.vpc.vpc_id

  depends_on = [module.vpc.vpc_id]
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
  vpc_id       = module.vpc.vpc_id
  key_name     = module.key.key_name
  ami          = data.aws_ami.ubuntu.id
  subnet_id    = module.vpc.p_subnet_id
  igw          = module.vpc.igw
  size         = "t3.medium"
}

module "eb" {
  source = "../../aws/eb"

  vpc_id              = module.vpc.vpc_id
  subnets             = [module.vpc.p2_subnet_id]
  elb_subnets         = [module.vpc.p_subnet_id, module.vpc.p2_subnet_id]
  tier                = "WebServer"
  solution_stack_name = "64bit Amazon Linux 2 v3.5.6 running Docker"
  elasticapp          = aws_elastic_beanstalk_application.wowee.name
  beanstalkappenv     = "production"
  iam_role_name       = aws_iam_instance_profile.test_profile.name
  ec2_key_name        = module.key.key_name
  sec_groups          = concat(module.sec_groups.sec_group_ids, module.priv_sec_groups.sec_group_ids)

  deployment_policy             = "Rolling"
  rolling_update_type           = "Immutable"
  rolling-update-max-batch-size = 2
  rolling-update-min-instances  = 1
  deregistration_delay          = 120

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
