data "aws_elastic_beanstalk_application" "application" {
  name = var.application_name
}

data "aws_elastic_beanstalk_hosted_zone" "current" {}

# --- ROUTE 53 ---
data "aws_route53_zone" "zone" {
  name = var.route53_zone_name
}

resource "aws_route53_record" "application" {
  name    = var.route53_record_url_prefix
  zone_id = data.aws_route53_zone.zone.zone_id
  type    = "A"
  alias {
    name                   = aws_elastic_beanstalk_environment.application.cname
    zone_id                = data.aws_elastic_beanstalk_hosted_zone.current.id
    evaluate_target_health = true
  }
}
# --- END ROUTE 53 ---

# TODO: Allow people to set extra settings through variables
resource "aws_elastic_beanstalk_environment" "application" {
  name                = var.environment_name
  description         = var.environment_description
  application         = data.aws_elastic_beanstalk_application.application.name
  solution_stack_name = var.environment_solution_stack_name

  # Tags
  tags = merge(
    var.tags,
    {
      "datadog_monitoring" = var.datadog_enabled ? "yes" : "no"
    },
  )

  # Application environment variables
  dynamic "setting" {
    for_each = var.application_environment_variables
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
    }
  }


  # Security groups
  dynamic "setting" {
    // Does not add SG if not provided
    for_each = var.security_groups

    content {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "SecurityGroups"
      value     = setting.value
    }
  }


  # Allows any setting to be set outside of the module
  # https://stackoverflow.com/questions/58594506/how-to-for-each-through-a-listobjects-in-terraform-0-12
  dynamic "setting" {
    for_each = var.settings
    content {
      namespace = setting.value["namespace"]
      name      = setting.value["name"]
      value     = setting.value["value"]
    }
  }


  # HTTPS - on EB config
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  # CLOUDWATCH
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = true
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckInterval"
    value     = 300
  }

  # HTTP to HTTPS (Application Load Balancer)
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "ListenerEnabled"
    value     = var.certificate_arn == "" ? "false" : "true"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = var.certificate_arn
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = var.deployment_policy
  }

  ###=========================== START Autoscale trigger ========================== ###
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.autoscale_min
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.autoscale_max
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = var.autoscale_measure_name
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = var.autoscale_statistic
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = var.autoscale_unit
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = var.autoscale_lower_bound
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerBreachScaleIncrement"
    value     = var.autoscale_lower_increment
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = var.autoscale_upper_bound
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperBreachScaleIncrement"
    value     = var.autoscale_upper_increment
  }
  ###=========================== END Autoscale trigger ========================== ###
}
data "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_elastic_beanstalk_environment.application.load_balancers[0]
  port              = 80
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = data.aws_lb_listener.http_listener.arn
  priority     = 1

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
