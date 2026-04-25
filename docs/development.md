# Development Guidelines

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes
4. Submit a pull request

## Module Development

- Each module should have: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md`
- Use descriptive variable names
- Add comments explaining complex logic
- Test modules locally before committing

## Versioning

- Use semantic versioning (MAJOR.MINOR.PATCH)
- Update CHANGELOG.md for each release
- Tag releases in Git

## Testing

- Use terraform-docs to generate module READMEs
- Validate configurations with `terraform validate`
- Test in a separate environment before production

## Code Style

- Use consistent indentation (2 spaces)
- Follow Terraform best practices
- Use typed variables where possible