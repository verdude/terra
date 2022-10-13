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
  source = "../../vpc/main"
}

module "sec_groups" {
  source = "../../sec_groups"
  vpc_id = module.vpc.vpc_id
}

module "keys" {
  source = "../../keys"
}

module "ec2" {
  source = "../../guru/aws/ec2"

  vpc_sec_gids = module.sec_groups.sec_group_ids
  vpc_id = module.vpc.vpc_id
  key_name = module.keys.key_name
  ami = data.aws_ami.ubuntu.id
  subnet_id = module.vpc.p_subnet_id
  igw = module.vpc.igw
  size = "t3.medium"
}

module "alb" {
  source = "../../alb"

  name = "main-alb"
  sec_groups = module.sec_groups.sec_group_ids
  subnets = [module.vpc.p_subnet_id, module.vpc.p2_subnet_id]
  vpc_id = module.vpc.vpc_id
  instance_id = module.ec2.id
  port = 22884
}

module "waf" {
  count = 0
  source = "../../guru/aws/waf"

  acl_name = "mybeautifulacl"
  region = "us-west-2"
  resource_arn = module.alb.lb_arn
  target_id = module.alb.lb_id

  managed_rule_groups = [
    {
      name            = "CommonRules"
      action = "block"
      priority        = 20

      statement = {
        name        = "AWSManagedRulesCommonRuleSet"

        excluded_rules = [
          "NoUserAgent_HEADER"
        ]
      }
    },
    {
      name = "BotRules"
      action = "block"
      priority = 10

      statement = {
        name = "AWSMAnagedRulesBotControlRuleSet"
      }
    },
    {
      name = "SQLiRules"
      action = "block"
      priority = 15

      statement = {
        name = "AWSManagedRulesSQLiRuleSet"
      }
    }
  ]
}
