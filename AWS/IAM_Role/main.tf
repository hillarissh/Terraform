terraform {
  backend "s3" {
    bucket       = "$STATE_BUCKET"
    key          = "$ENVIRONMENT_STAGE/Platform-iamRole-$ENVIRONMENT_STAGE.tfstate"
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
module "Platform_Lambda_Default_Role" {
  source           = "github.com/Org/Repo//modules/IAM_Role/?ref=v1.0.7"
  project_name     = "Platform"
  environment      = "$ENVIRONMENT_STAGE_V2"
  role_name        = "LambdaDefaultRole"
  role_description = "Allow access to multiple services for Lambda"
  policy_arn_list = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/Platform-$ENVIRONMENT_STAGE_V2-LambdaDynamoDB",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/Platform-$ENVIRONMENT_STAGE_V2-LambdaExecution",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/Platform-$ENVIRONMENT_STAGE_V2-LambdaSQS",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/Platform-$ENVIRONMENT_STAGE_V2-LambdaSSM",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/Platform-$ENVIRONMENT_STAGE_V2-LambdaVPC",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/Platform-$ENVIRONMENT_STAGE_V2-LambdaEventBridge",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/Platform-$ENVIRONMENT_STAGE_V2-LambdaStepFunction",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/Platform-$ENVIRONMENT_STAGE_V2-LambdaAppConfig"
  ]
  role_assume_policy = "files/lambda_role_trust.json"
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
