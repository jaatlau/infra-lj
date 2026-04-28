# Infra LJ - Terraform Infrastructure Repository

Central infrastructure repository that provisions and manages global infrastructure resources. 
Uses Terraform Cloud for state management and Doppler for secrets management.

## Quick Start

### Prerequisites
- GitHub account
- Doppler account
- Terraform Cloud account

### Setup Steps

#### 1. Doppler Setup
- Create a Doppler project
- create service tokens for dev and prod environments

#### 2. GitHub Setup
Add doppler service tokens to your GitHub repository:
- `DOPPLER_DEV_TOKEN`: Doppler token for dev environment
- `DOPPLER_PROD_TOKEN`: Doppler token for prod environment

#### 3. Terraform Cloud Setup
- Create organization in Terraform Cloud
- Create workspaces for dev and prod
- Generate API token and add it to Doppler

#### 4. Deployment
Trigger the provision workflow from GitHub Actions:
Use GitHub UI: Actions → Provision Infra → Run workflow
```

## How It Works

1. **Developer** manually triggers the provision workflow
2. **GitHub Actions** runs the provision.yml workflow
3. **Doppler CLI** injects secrets into the environment
4. **Terraform** uses those secrets to authenticate with Terraform Cloud
5. **Resources** are provisioned and state is stored in Terraform Cloud

## Directory Structure

```
.
├── main.tf                      # Root module with provider + resources
├── versions.tf                  # Terraform Cloud backend config
├── variables.tf                 # Root variables (from Doppler)
├── outputs.tf                   # Root outputs for consuming repos
├── .github/workflows/
│   ├── provision.yml            # Manual deployment workflow
│   └── ci.yml                   # Docs generation on push
└── modules/                     # Reusable modules
    ├── storage/s3/              # S3 bucket resources
    ├── compute/                 # Compute resources
    └── iam/                     # IAM roles
```

## Development

See [docs/development.md](docs/development.md) for contribution guidelines.

## Architecture

See [docs/architecture.md](docs/architecture.md) for design decisions.