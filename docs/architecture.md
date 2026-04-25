# Architecture

## Overview

This repository provides reusable Terraform modules for AWS infrastructure components. The modules are designed to be composable, allowing other repositories to build complex infrastructures by combining them.

## Module Structure

- **vpc/**: Manages VPC, subnets, security groups, and internet gateways
- **compute/**: Handles EC2 instances, auto-scaling groups, and launch templates
- **networking/**: Additional networking resources like load balancers, VPNs

## Design Principles

- Flat hierarchy to keep modules simple and focused
- Clear separation of concerns
- Extensive use of variables and outputs for composability
- Consistent naming conventions

## Terraform Cloud Integration

All deployments use Terraform Cloud for remote state management and execution, ensuring consistency across environments.

## Dependency Management

Modules are versioned semantically. Consuming repos pin to specific versions to avoid breaking changes.