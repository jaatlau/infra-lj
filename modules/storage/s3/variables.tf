# PROJECT
variable "ENVIRONMENT" {
  description = "dev or prod"
  type        = string
}

# STORAGE - S3
variable "AWS_BUCKET" {
  description = "S3 bucket name"
  type        = string
}

variable "AWS_IAM_USER_DEPLOYER" {
  description = "arn of the user who deploys"
  type        = string
}