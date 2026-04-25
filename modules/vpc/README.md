# VPC Module

This module creates a basic VPC with an Internet Gateway.

## Usage

```hcl
module "vpc" {
  source = "../modules/vpc"

  cidr_block = "10.0.0.0/16"
  name       = "my-vpc"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cidr_block | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| name | Name tag for the VPC | `string` | `"main-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the created VPC |
| internet_gateway_id | ID of the created Internet Gateway |