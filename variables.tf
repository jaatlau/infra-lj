# PROJECT
variable "ENVIRONMENT" {
  description = "dev or prod"
  type        = string
}

# PROVIDERS
variable "AWS_REGION" {
  description = "AWS region"
  type        = string
}

variable "AWS_ACCESS_KEY" {
  description = "access key of deploy user"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "secret of the access key"
  type        = string
}

# STORAGE - S3
variable "AWS_BUCKET" {
  description = "S3 bucket name"
  type        = string
}

