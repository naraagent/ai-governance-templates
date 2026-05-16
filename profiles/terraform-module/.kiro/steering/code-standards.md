---
inclusion: auto
---

# Code Standards — Terraform Module

## Terraform

- Version >= 1.7, providers pinned
- All variables: `description` + `type` required
- All outputs: `description` required
- All resources: tagged (Environment, Service, Team, ManagedBy)

## Security (CRITICAL)

- No credentials in .tf files
- IAM roles (not access keys)
- All storage encrypted at rest
- Security groups: least privilege
- No `0.0.0.0/0` on SSH/RDP ingress
- VPC flow logs in production
- KMS for sensitive data

## State

- S3 remote state with encryption + versioning
- DynamoDB locking
- Never commit .terraform/ or *.tfstate
- Separate state per environment

## Naming

- Resources: `snake_case` with service prefix
- Variables/Outputs: `snake_case`, descriptive
- Tags: PascalCase keys

## Agent Restrictions (CRITICAL)

- NEVER run `terraform apply` or `terraform destroy`
- NEVER modify state manually
- Only: init, validate, plan, fmt, lint
- All changes require human approval before apply

## Git

- Branch: `type/TICKET-description`
- Commit: `type(scope): description`
- PR must include `terraform plan` output
