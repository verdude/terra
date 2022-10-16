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

// resources
module "vpc" {
  source = "../../aws/vpc/main"
}

module "sec_groups" {
  source = "../../aws/sec_groups"
  vpc_id = module.vpc.vpc_id
}

module "keys" {
  source = "../../aws/keys"
}

module "ec2" {
  source = "../../aws/ec2"

  vpc_sec_gids = module.sec_groups.sec_group_ids
  vpc_id = module.vpc.vpc_id
  key_name = module.keys.key_name
  ami = data.aws_ami.ubuntu.id
  subnet_id = module.vpc.p_subnet_id
  igw = module.vpc.igw
  size = "t3.medium"
}

module "alb" {
  source = "../../aws/alb"

  name = "main-alb"
  sec_groups = module.sec_groups.sec_group_ids
  subnets = [module.vpc.p_subnet_id, module.vpc.p2_subnet_id]
  vpc_id = module.vpc.vpc_id
  instance_id = module.ec2.id
  target_port = 22884
  port = 80
}

module "waf" {
  source = "../../aws/waf"

  acl_name = "mybeautifulacl"
  region = "us-west-2"
  resource_arn = module.alb.lb_arn

  managed_rule_groups = {
    "CommonRules" = {
      action = "block"
      priority = 20

      statement = {
        name = "AWSManagedRulesCommonRuleSet"
      }
    }
  }
}
