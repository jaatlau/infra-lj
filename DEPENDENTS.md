# Dependent Repositories

This file tracks repositories that consume modules from this infra repository.

## Format

- **Repository**: Name of the consuming repo
- **Module(s) Used**: Which modules are referenced
- **Version**: Pinned version or ref
- **Contact**: Point of contact for updates

## Current Dependents

| Repository | Module(s) Used | Version | Contact |
|------------|----------------|---------|---------|
| example-repo | vpc, compute | v1.0.0 | @user |

## Adding a New Dependent

When your repository starts using modules from here, add an entry above and notify the infra team.