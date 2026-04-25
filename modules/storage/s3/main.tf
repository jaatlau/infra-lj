resource "aws_s3_bucket" "data-platform-bucket" {
  bucket = var.AWS_BUCKET

  force_destroy = true  # This allows deletion even with objects inside

  tags = {
    Environment = var.ENVIRONMENT
    ManagedBy   = "Terraform"
  }
}

