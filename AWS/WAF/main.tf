terraform {
  backend "s3" {
    bucket       = "$STATE_BUCKET"
    key          = ""
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
  required_version = ">= 1.9.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.1.0"
    }
  }
}
provider "aws" {
  region = "eu-west-1"
}
data "aws_caller_identity" "current" {}

###We're using a module from terraform registry for this cause WAFv2 is complex to build from scratch######
module "module_name" {
  source         = "aws-ss/wafv2/aws"
  version        = "4.1.3"
  name           = "Platform-Default-WAF"
  rule           = local.waf_rules
  default_action = "allow"
  resource_arn   = local.services_arn
  scope          = "REGIONAL"
  visibility_config = {
    "sampled_requests_enabled"   = true,
    "cloudwatch_metrics_enabled" = true,
    "metric_name"                = "Platform-Default-WAF"
  }
  association_config = {
    request_body = {
      api_gateway = {
        default_size_inspection_limit = "KB_64"
      }
    }
  }
  tags = {
    managed_by          = "Terraform"
    warning_description = "This is a terraform project DO NOT edit directly in AWS Console"
    BUDGET              = ""
    BUSINESS            = ""
    COST_CENTRE         = ""
    PROJECT             = ""
    Environment         = "$ENVIRONMENT_STAGE_V2"
  }
}

import {
  to = module.module_name.module_name_web_acl.this
  id = ""
}
