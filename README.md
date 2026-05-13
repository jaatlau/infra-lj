# Infra LJ - Terraform Infrastructure Repository

Central infrastructure repository that provisions and manages global infrastructure resources. 
Uses Terraform Cloud for state management and Doppler for secrets management.

## Quick Start

### Prerequisites
- GitHub account
- Doppler account
- Terraform Cloud account
- Hetzner account

### Setup Steps

#### 1. Doppler Setup
- Create a Doppler project
- create service tokens for dev and prod environments
- Its important to name doppler secrets properly:
-- for instance TF_VAR prefix -> automatically picked as terraform variables
-- for instance TERRAFORM_CLOUD_ORGANIZATION -> automatically picked as terraform provider organization (required)
-- for instance TERRAFORM_CLOUD_WORKSPACE -> automatically picked as terraform provider workspace (required for choosing correct environment)

#### 2. GitHub Setup
Add doppler service tokens to your GitHub repository:
- `DOPPLER_DEV_TOKEN`: Doppler token for dev environment
- `DOPPLER_PROD_TOKEN`: Doppler token for prod environment

#### 3. Terraform Cloud Setup
- Create organization in Terraform Cloud
- Create workspaces for dev and prod
- Generate API token and add it to Doppler

#### 4. Hetzner Setup
- Create project
- Create api key
- Save api key to Doppler

#### 5. Local
- Create ssh key
- Save public key to Doppler

#### 6. Deployment
- Make sure that what stack you're about to deploy that you check it's main.tf and check that all necessary variables are there and in Doppler as well
Trigger the provision workflow from GitHub Actions:
Use GitHub UI: Actions → Provision Infra → Run workflow
```

### 7. After Deployment
- Any resources' (like cloud servers) bootstrap scripts and details can be found under the same module where the resource is created.
- So after deployment there might be some manual bootstrap scripts to run. (maybe automated later)


## How It Works

1. **Developer** manually triggers the provision workflow
2. **GitHub Actions** runs the provision.yml workflow
3. **Doppler CLI** injects secrets into the environment at runtime
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