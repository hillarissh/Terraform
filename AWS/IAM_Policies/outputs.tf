output "IAM_General_Policy_ARN" {
  value = module.Platform_Policy.IAM_Policy_ARN
}
output "IAM_Lambda_EventBridge_ARN" {
  value = module.Platform_Lambda_EventBridge_Policy.IAM_Policy_ARN
}
output "IAM_Lambda_Dynamo_ARN" {
  value = module.Platform_Lambda_DynamoDB_Policy.IAM_Policy_ARN
}
output "IAM_Lambda_Execution_ARN" {
  value = module.Platform_Lambda_Execution_Policy.IAM_Policy_ARN
}
output "IAM_Lambda_SQS_ARN" {
  value = module.Platform_Lambda_SQS_Policy.IAM_Policy_ARN
}
output "IAM_Lambda_SSM_ARN" {
  value = module.Platform_Lambda_SSM_Policy.IAM_Policy_ARN
}
output "IAM_Lambda_VPC_ARN" {
  value = module.Platform_Lambda_VPC_Policy.IAM_Policy_ARN
}
