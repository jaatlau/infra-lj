# Compute Module

This module creates an EC2 instance.

## Usage

```hcl
module "compute" {
  source = "../modules/compute"

  ami_id     = "ami-12345678"
  subnet_id  = module.vpc.public_subnets[0]
  name       = "my-instance"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| ami_id | AMI ID for the instance | `string` | n/a | yes |
| instance_type | Instance type | `string` | `"t2.micro"` | no |
| security_group_ids | List of security group IDs | `list(string)` | `[]` | no |
| subnet_id | Subnet ID to launch the instance in | `string` | n/a | yes |
| name | Name tag for the instance | `string` | `"main-instance"` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the created EC2 instance |
| public_ip | Public IP of the instance |