# Infra LJ - Terraform Infrastructure Repository

Central infrastructure repository that provisions and manages AWS infrastructure resources. Uses Terraform Cloud for state management and Doppler for secrets management.

## Quick Start

### Prerequisites
- GitHub account
- Doppler account (free tier available at https://www.doppler.com)
- Terraform Cloud account
- AWS account

### Setup Steps

#### 1. Doppler Setup
- Create a Doppler project
- create tokens for dev and prod environments
- Add these secrets to each environment:
  ```
  AWS_REGION
  AWS_ACCESS_KEY
  AWS_SECRET_ACCESS_KEY
  AWS_BUCKET
  ENVIRONMENT
  TF_API_TOKEN (Terraform Cloud API token)
  ```

#### 2. GitHub Setup
Add secrets to your GitHub repository:
- `DOPPLER_DEV_TOKEN`: Doppler token for dev environment
- `DOPPLER_PROD_TOKEN`: Doppler token for prod environment

(AWS credentials are NOT stored in GitHub — they come from Doppler)

#### 3. Terraform Cloud Setup
- Create organization in Terraform Cloud
- Create workspaces: `infra-dev` and `infra-prod`
- Generate API token and add it to Doppler as `TF_API_TOKEN`

#### 4. Deploy Manually
Trigger the provision workflow from GitHub Actions:
```bash
# Via GitHub CLI
gh workflow run provision.yml -f confirm=PROVISION -f environment=dev

# Or use GitHub UI: Actions → Provision Infra → Run workflow
```

## How It Works

1. **Developer** manually triggers the provision workflow
2. **GitHub Actions** runs the provision.yml workflow
3. **Doppler CLI** injects secrets into the environment
4. **Terraform** uses those secrets to authenticate with AWS and Terraform Cloud
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