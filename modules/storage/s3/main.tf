resource "aws_s3_bucket" "data_platform_bucket" {
  bucket = var.AWS_BUCKET

  force_destroy = true  # This allows deletion even with objects inside

  tags = {
    Environment = var.ENVIRONMENT
    ManagedBy   = "Terraform"
  }
}

#create iam role to access bucket
resource "aws_iam_role" "deploy_role" {
  name               = "${var.ENVIRONMENT}-deploy-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          AWS = "${var.AWS_IAM_USER_DEPLOYER}"
        }
      }
    ]
  })
}

#create policy for iam role to access bucket
resource "aws_iam_policy" "bucket_policy" {
  name        = "${var.ENVIRONMENT}-bucket-policy"
  description = "Allow access to ${var.AWS_BUCKET}"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.data_platform_bucket.arn,
          "${aws_s3_bucket.data_platform_bucket.arn}/*"
        ]
      }
    ]
  })
}

#attach the policy to iam role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.deploy_role.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}