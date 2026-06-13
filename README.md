# Infra LJ - Terraform Infrastructure Repository

Central infrastructure repository that provisions and manages global infrastructure resources. 
Uses Terraform Cloud for state management and Doppler for secrets management.

## Guidelines
- Each stacks/ subfolder is a deployable solution.

- Each solution points to same global Terraform Cloud organization and organization's default project.

- Each solution should have its own Terraform Cloud workspace for dev and prod environments.

- When creating Terraform Cloud workspaces, remember to add working directory setting to solution subfolder (e.g. stacks/data-platform), otherwise relative paths to modules sources wont work

- Each solution should have its own Doppler project.


### Naming conventions
- Terraform Cloud workspace: {solution-name-as-in-subfolder}-{dev/prod}
- Doppler project: {solution-name-as-in-subfolder}
- Github Doppler secret: DOPPLER_{solution-name-as-in-subfolder}_{dev/prod} (Github secrets do not accept '-' so we replace any '-' with '_')


## Quick Start

### Prerequisites
- GitHub account
- Doppler account
- Terraform Cloud account

### Setup Steps

#### 1. Doppler Setup
- Create a Doppler project with proper name
- create service tokens for dev and prod environments and add them as DOPPLER_TOKEN_DEV and DOPPLER_TOKEN_PROD secrets
- Its important to name doppler secrets properly:
-- for instance TF_VAR prefix -> automatically picked as terraform variables
-- for instance TERRAFORM_CLOUD_ORGANIZATION -> automatically picked as terraform provider organization (required)
-- for instance TERRAFORM_CLOUD_WORKSPACE -> automatically picked as terraform provider workspace (required for choosing correct environment)


#### 2. GitHub Setup
Add doppler service tokens to your GitHub repository as secrets

#### 3. Terraform Cloud Setup
- Create organization in Terraform Cloud and add it to Doppler as TERRAFORM_CLOUD_ORGANIZATION
- Create workspaces for solution (dev and prod) and add them to Doppler as TERRAFORM_CLOUD_WORKSPACE
- For each workspace define working directory of stacks/{solution-name}, so that modules relative paths work properly
- Generate API token and add it to Doppler (same api token can be used to multiple deployments)

#### 4. Deployment
Under stacks/ we define verified solutions that can be deployed.
Each stack subfolder is its own solution.
Deployment occurs using provision.yml workflow file.

Inputs for provision.yml:
- environment {dev/prod} - required
- name of the solution (subfolder) - required

```
## How It Works

1. **Developer** manually triggers the provision workflow
2. **GitHub Actions** runs the provision.yml workflow
3. **Doppler CLI** injects secrets into the environment at runtime
4. **Terraform** uses those secrets to authenticate with Terraform Cloud and using any variables required for deployment.
5. **Resources** are provisioned and state is stored in Terraform Cloud


## Directory Structure

.
├── .github/
│   └── workflows/
│       └── provision.yml        # Manual deploy workflow
│       └── destroy.yml          # Manual destroy solution workflow
├── modules/                     # Reusable, shared modules
│   ├── security/
│   │   └── firewall/
│   │       └── main.tf
│   ├── server/
│   │   └── hetzner/
│   │       └── main.tf
│   └── storage/
│       └── s3/
│           └── main.tf
└── stacks/                      # Deployable stacks
    └── <solution-name>/
        ├── main.tf
        └── variables.tf

```