
# Terraform Cloud and providers
terraform {
  required_version = ">= 1.7.0"
  cloud {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  
}

provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_ACCESS_KEY
}


# storage

module "data-platform-bucket" {
  source      = "./modules/storage/s3"
  AWS_BUCKET  = var.AWS_BUCKET
  ENVIRONMENT = var.ENVIRONMENT
}


