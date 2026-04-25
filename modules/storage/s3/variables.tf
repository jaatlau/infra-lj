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