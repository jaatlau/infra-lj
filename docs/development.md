# Development Guidelines

## Contributing

1. Create a feature branch from main
2. Make changes (add/modify modules or resources)
3. Commit and push to your branch
4. Create Pull Request — describe changes
5. Merge to main after approval

## Module Development Workflow

### Adding a New Module

1. **Create module directory**:
   ```bash
   mkdir -p modules/my-resource
   ```

2. **Create standard files**:
   ```bash
   touch modules/my-resource/{main,variables,outputs,versions}.tf
   ```

3. **Define resources in main.tf**:
   - Only resource definitions
   - No provider config
   - Use descriptive variable references

4. **Define inputs in variables.tf**:
   ```hcl
   variable "environment" {
     description = "Environment name"
     type        = string
   }
   ```

5. **Define outputs in outputs.tf (if needed)**:
   ```hcl
   output "resource_id" {
     value = aws_resource.my_resource.id
   }
   ```

6. **Set provider requirements in versions.tf (if needed)**:
   ```hcl
   terraform {
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 6.0"
       }
     }
   }
   ```

7. **Generate documentation**:
   ```bash
   cd modules/my-resource
   export PATH=$PATH:~/bin
   terraform-docs markdown table --output-file README.md .
   ```

8. **Add module to root main.tf**:
   ```hcl
   module "my_resource" {
     source      = "./modules/my-resource"
     environment = var.environment
   }
   ```

9. **Add root outputs**:
   ```hcl
   output "my_resource_id" {
     value = module.my_resource.resource_id
   }
   ```

### Deploy to Dev
1. Commit and push your changes to main
2. Manually trigger dev workflow:
   ```bash
   gh workflow run provision.yml -f confirm=PROVISION -f environment=dev
   ```
3. Review Terraform plan output in GitHub Actions
4. Workflow auto-applies if plan looks correct
5. Verify resources in AWS console before promoting to prod

## Code Style

- **Indentation**: 2 spaces
- **Naming**: snake_case for resources, UPPERCASE for secrets/variables
- **Comments**: Explain the "why", not the "what"
- **Outputs**: Always include descriptions
- **Variables**: Use typed variables with descriptions
- **Modules**: Keep focused — one concept per module

## Best Practices

1. **Never commit secrets** — use Doppler only
2. **Use descriptive names** — variables, resources, modules
3. **Comment complex logic** — aid AI and humans
4. **Test in dev first** — always run in dev before prod
5. **Review terraform plan output** — before accepting apply
6. **Keep modules focused** — one concept per module
7. **Update module READMEs** — after adding/changing variables
8. **Check Terraform fmt** — before committing