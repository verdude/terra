data "aws_instance" "eb_instance" {
  instance_id = module.eb.instances[0]
}

module "vpc" {
  source = "../../aws/vpc/main"
}

module "key" {
  source = "../../aws/keys"
}

module "eb" {
  source = "../../aws/eb"

  vpc_id = module.vpc.vpc_id
  public_subnets = [module.vpc.p_subnet_id, module.vpc.p2_subnet_id]
  elb_public_subnets = [module.vpc.p_subnet_id, module.vpc.p2_subnet_id]
  tier = "WebServer"
  solution_stack_name = "64bit Amazon Linux 2 v3.5.0 running Docker"
  elasticapp = "wowee"
  beanstalkappenv = "production"
  iam_role_name = aws_iam_instance_profile.test_profile.name
  ec2_key_name = module.key.key_name
}

module "waf" {
  source = "../../aws/waf"

  acl_name = "mybeautifulacl"
  associated_arns = {
    main = module.eb.load_balancers[0]
  }

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
