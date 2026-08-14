terraform {
  backend "s3" {
    bucket       = "%state_bucket%"
    key          = "%environment_stage%/platform-iamPolicy-%environment_stage%.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
  required_version = ">= 1.9.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84.0"
    }
  }
}
provider "aws" {
  region = "eu-west-1"
}
data "aws_caller_identity" "current" {}
##GENERAL AWS ACCESS##
module "platform_Policy" {
  source = "github.com/OrgName/repo//modules/IAM_Policy/?ref=v1.0.7"
  #source              = "./modules/IAM_Policy"
  project_name       = "platform"
  environment        = "%environment_stage_v2%"
  policy_name        = "AllowAWSAccess"
  policy_description = "Allow controlled Services access"
  policy_file        = "files/github_iam.json"
  standard_tags = {
    managed_by          = "Terraform"
    warning_description = "This is a terraform project DO NOT edit directly in AWS Console"
    BUDGET              = ""
    BUSINESS            = ""
    COST_CENTRE         = ""
    PROJECT             = ""
    Environment         = "$ENVIRONMENT_STAGE_V2"
  }
}
module "platform_Lambda_DynamoDB_Policy" {
  source = "github.com/OrgName/repo//modules/IAM_Policy/?ref=v1.0.7"
  #source              = "./modules/IAM_Policy"
  project_name       = "platform"
  environment        = "%environment_stage_v2%"
  policy_name        = "LambdaDynamoDB"
  policy_description = "Allow Lambda to access DynamoDB"
  policy_file        = "files/lambda_dynamodb.json"
  standard_tags = {
    managed_by          = "Terraform"
    warning_description = "This is a terraform project DO NOT edit directly in AWS Console"
    BUDGET              = ""
    BUSINESS            = ""
    COST_CENTRE         = ""
    PROJECT             = ""
    Environment         = "$ENVIRONMENT_STAGE_V2"
  }
}

#insert other modules here...
