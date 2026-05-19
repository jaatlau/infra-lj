# Infra LJ - Terraform Infrastructure Repository

Central infrastructure repository that provisions and manages global infrastructure resources. 
Uses Terraform Cloud for state management and Doppler for secrets management.

## Guidelines
Each stacks/ subfolder is deployable solution.
Each solution should have subfolder for version, starting with 1 and increment by 1 when new version is created.
Each solution should have its own Terraform Cloud workspace for dev and prod environments.
Each solution points to same global Terraform Cloud organization
Each solution should have its own Doppler project.
By default workflow files deploy latest version of the solution. Given version number as input, that version will be deployed.


### Naming conventions
Terraform Cloud workspace: {solution-name-as-in-subfolder}-{dev/prod}
Doppler project: {solution-name-as-in-subfolder}
Github Doppler secret: DOPPLER-{solution-name-as-in-subfolder}-{dev/prod}
Solution version subfolder: v{version_number}


## Quick Start

### Prerequisites
- GitHub account
- Doppler account
- Terraform Cloud account

### Setup Steps

#### 1. Doppler Setup
- Create a Doppler project with proper name
- create service tokens for dev and prod environments
- Its important to name doppler secrets properly:
-- for instance TF_VAR prefix -> automatically picked as terraform variables
-- for instance TERRAFORM_CLOUD_ORGANIZATION -> automatically picked as terraform provider organization (required)
-- for instance TERRAFORM_CLOUD_WORKSPACE -> automatically picked as terraform provider workspace (required for choosing correct environment)


#### 2. GitHub Setup
Add doppler service tokens to your GitHub repository as secrets

#### 3. Terraform Cloud Setup
- Create organization in Terraform Cloud and add it to Doppler as TERRAFORM_CLOUD_ORGANIZATION
- Create workspaces for dev and prod and add them to Doppler as TERRAFORM_CLOUD_WORKSPACE
- Generate API token and add it to Doppler

#### 4. Deployment
Under stacks/ we define verified solutions that can be deployed.
Each stack subfolder is its own solution.
Deployment occurs using provision.yml workflow file.

Inputs for provision.yml:
- name of the solution (subfolder) - required
- environment {dev/prod} - required
- version number - optional, if not given the latest version will be deployed


```




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
