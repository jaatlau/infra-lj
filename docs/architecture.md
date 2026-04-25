# Architecture

## Overview

This repository serves as the **infrastructure provider** for the organization. It provisions core AWS resources that other repositories consume via Terraform state outputs (Model A architecture).

- This repo **creates and manages** actual infrastructure
- Single source of truth for infrastructure state
- Prevents resource conflicts and drift

## Deployment Model: Manual

- **No automatic deployments** on code push
- All infrastructure changes require **manual approval** via GitHub Actions
- Workflow: Commit → Review → Manually trigger provision.yml → Terraform applies

This ensures:
- Careful review before production changes
- Reduced risk of unintended infrastructure changes
- Clear audit trail of who deployed what and when

## Secrets Management

### Doppler Integration
- **All secrets** stored in Doppler (AWS credentials, API tokens, etc.)
- **GitHub only stores**: Doppler tokens (rotate regularly)
- **Terraform variables** injected at runtime via `doppler run`
- Benefits: Centralized audit logs, secret rotation, compliance

### Deployment Flow
1. Developer manually triggers provision.yml workflow
2. GitHub Actions runs provision.yml
3. Doppler CLI authenticates using DOPPLER_TOKEN secret from GitHub
4. `doppler run` injects all secrets into environment
5. Terraform applies configuration with injected secrets
6. Terraform Cloud stores state (encrypted at rest)

## Module Structure

- **vpc/**: VPC, subnets, security groups, internet gateways
- **compute/**: EC2 instances, auto-scaling groups, launch templates
- **storage/s3/**: S3 bucket resources
- **iam/**: IAM roles and policies

### Module Design Principles

- **Flat hierarchy**: Keep modules simple and focused
- **Self-contained**: Each module has main.tf, variables.tf, outputs.tf, versions.tf
- **Provider-agnostic**: No provider config inside modules
- **Clear contracts**: Typed variables and outputs for reusability
- **Consistent naming**: snake_case for resources, UPPERCASE for secrets

## State Management

- **Backend**: Terraform Cloud (remote state)
- **Locking**: Automatic (prevents concurrent changes)
- **Encryption**: At rest (Terraform Cloud managed)
- **State outputs**: Readable by consuming repos

## Environment Strategy

- **dev**: Development environment (test infrastructure changes)
- **prod**: Production environment (stable, carefully managed)
- Separate Doppler projects and Terraform Cloud workspaces per environment
- Recommended: Test in dev first via manual workflow trigger